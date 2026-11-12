#!/usr/bin/env bash
# Uebung 08.1: fasst die Pruefungen fuer Kea DHCPv4 zusammen.
# Aufruf: sudo ./08.1-kea-pruefen.sh [Konfigurationsdatei]
set -u
KONF="${1:-/etc/kea/kea-dhcp4.conf}"

echo "== Version";      kea-dhcp4 -V 2>&1 | head -1
echo "== Konfig pruefen: $KONF"
if kea-dhcp4 -t "$KONF" >/dev/null 2>&1; then echo "OK"; else echo "FEHLER:"; kea-dhcp4 -t "$KONF" 2>&1 | grep -i error | head -3; fi
echo "== Rechte";       ls -l "$KONF"
echo "== Dienst";       systemctl is-active kea-dhcp4-server 2>&1
echo "== Letzte Meldungen"; journalctl -u kea-dhcp4-server -n 15 --no-pager 2>&1
echo "== Leases";       cat /var/lib/kea/kea-leases4.csv 2>&1
