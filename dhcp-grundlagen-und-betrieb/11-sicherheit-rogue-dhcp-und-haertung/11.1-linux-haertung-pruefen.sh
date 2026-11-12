#!/usr/bin/env bash
# Uebung 11.1: Nur-Lese-Pruefung der Haertung von Kea auf SRV-LIN-KEA. Aendert nichts.
# Aufruf: sudo ./11.1-linux-haertung-pruefen.sh
set -u
KONF=/etc/kea/kea-dhcp4.conf
echo "== Rechte der Konfiguration"
if [ -f "$KONF" ]; then stat -c '%U:%G %a %n' "$KONF"; else echo "fehlt: $KONF"; fi
echo "   Soll: root:_kea 640 (weder fuer alle lesbar noch fuer _kea unlesbar)"
echo "== Lauschende UDP-Sockets (DHCP: Port 67)"
ss -lunp 2>/dev/null | grep -E ':67\b' || echo "kein Socket auf Port 67 (Dienst laeuft nicht oder nutzt raw-Sockets)"
echo "   Hinweis: Kea nutzt standardmaessig raw-Sockets; fehlende Treffer sind kein Fehler"
echo "== Kea-Prozesse und Benutzer"
ps -eo user,comm | awk '$2 ~ /^kea/ {print}'
echo "== Weitere Kea-Dienste (Control Agent o. ae.)"
systemctl list-unit-files 'kea-*' --no-legend 2>/dev/null || echo "systemctl nicht verfuegbar"
echo "== Firewall (ufw), falls vorhanden"
if command -v ufw >/dev/null; then ufw status 2>&1 | head -10; else echo "ufw nicht installiert"; fi
