#!/usr/bin/env bash
# Mitschnitt von DHCP-Verkehr auf einer Schnittstelle (Uebung 01.1).
# Aufruf: sudo ./01.1-mitschnitt.sh net-a [Anzahl-Pakete]
# Schreibt nichts auf die Platte; Strg+C beendet.
set -euo pipefail

schnittstelle="${1:-}"
anzahl="${2:-}"
if [[ -z "$schnittstelle" ]]; then
    echo "Aufruf: $0 <Schnittstelle> [Anzahl-Pakete]" >&2
    echo "Vorhandene Schnittstellen:" >&2
    ip -br link >&2
    exit 1
fi
if ! ip link show "$schnittstelle" >/dev/null 2>&1; then
    echo "Schnittstelle $schnittstelle existiert nicht." >&2
    exit 1
fi

optionen=(-n -e -vv -i "$schnittstelle")
if [[ -n "$anzahl" ]]; then
    optionen+=(-c "$anzahl")
fi
exec tcpdump "${optionen[@]}" 'udp port 67 or udp port 68'
