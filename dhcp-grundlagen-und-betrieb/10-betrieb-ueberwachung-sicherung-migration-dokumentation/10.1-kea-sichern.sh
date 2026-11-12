#!/usr/bin/env bash
# Uebung 10.1: sichert Konfiguration und Lease-Datei von Kea in ein Archiv.
# Aufruf: sudo ./10.1-kea-sichern.sh [Zielordner]   (Standard: /var/backups/kea)
set -eu
ZIEL="${1:-/var/backups/kea}"
STAMP="$(date +%Y%m%d-%H%M%S)"
mkdir -p "$ZIEL"
ARCHIV="$ZIEL/kea-$STAMP.tar.gz"
# Nur vorhandene Dateien aufnehmen
DATEIEN=()
for f in /etc/kea/kea-dhcp4.conf /etc/kea/kea-dhcp6.conf /var/lib/kea/kea-leases4.csv /var/lib/kea/kea-leases6.csv; do
    [ -f "$f" ] && DATEIEN+=("$f")
done
if [ "${#DATEIEN[@]}" -eq 0 ]; then echo "Keine Kea-Dateien gefunden." >&2; exit 1; fi
tar -czf "$ARCHIV" "${DATEIEN[@]}"
chmod 600 "$ARCHIV"
echo "Archiv: $ARCHIV"
tar -tzf "$ARCHIV"
