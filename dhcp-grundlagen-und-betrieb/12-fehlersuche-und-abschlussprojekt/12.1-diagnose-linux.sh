#!/usr/bin/env bash
# Uebung 12.1: sammelt Diagnosedaten fuer DHCP auf einem Linux-Router/Relay oder Kea-Server.
# Nur lesend. Aufruf: sudo ./12.1-diagnose-linux.sh [Schnittstelle fuer 10-Sekunden-Mitschnitt]
set -u
IFACE="${1:-}"
echo "== Datum";            date
echo "== Schnittstellen";   ip -br addr
echo "== Routen";           ip route
echo "== IPv4-Weiterleitung"; sysctl -n net.ipv4.ip_forward 2>/dev/null
echo "== Relay-Konfiguration"
[ -f /etc/default/isc-dhcp-relay ] && grep -vE '^\s*(#|$)' /etc/default/isc-dhcp-relay || echo "keine /etc/default/isc-dhcp-relay"
echo "== Dienste"
for d in isc-dhcp-relay kea-dhcp4-server kea-dhcp6-server radvd; do
  st="$(systemctl is-active "$d" 2>/dev/null || true)"
  printf '%-22s %s\n' "$d" "${st:-unbekannt}"
done
echo "== Kea-Konfiguration pruefen"
if [ -f /etc/kea/kea-dhcp4.conf ]; then
  if kea-dhcp4 -t /etc/kea/kea-dhcp4.conf >/dev/null 2>&1; then echo "OK"; else kea-dhcp4 -t /etc/kea/kea-dhcp4.conf 2>&1 | grep -iE 'error|fail' | head -3; fi
fi
echo "== Letzte DHCP-Meldungen (journald)"
journalctl -u kea-dhcp4-server -u isc-dhcp-relay -n 15 --no-pager 2>/dev/null || echo "journalctl nicht verfuegbar"
if [ -n "$IFACE" ]; then
  echo "== 10 Sekunden DHCP-Mitschnitt auf $IFACE (Anfragen jetzt ausloesen)"
  timeout 10 tcpdump -l -nei "$IFACE" 'udp and (port 67 or port 68)' 2>&1 | head -40 || true
fi
