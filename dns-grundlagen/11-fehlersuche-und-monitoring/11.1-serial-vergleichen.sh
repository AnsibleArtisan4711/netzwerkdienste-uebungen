#!/bin/bash
# Uebung 11.1: Vergleicht die SOA-Seriennummer einer Zone auf mehreren Servern (nur lesend).
# Aufruf:  bash 11.1-serial-vergleichen.sh <zone> <server1> <server2> [weitere Server]
# Beispiel: bash 11.1-serial-vergleichen.sh branch.example.org 192.168.50.11 192.168.50.10
# Ergebnis 0 = alle gleich, 1 = Abweichung (Sekundaer hinkt hinterher oder Seriennummer wurde nicht erhoeht), 2 = Aufruf falsch.

if [ "$#" -lt 3 ]; then echo "Aufruf: $0 <zone> <server1> <server2> [...]" >&2; exit 2; fi
zone="$1"; shift
erste=""; abweichung=0
for srv in "$@"; do
    soa="$(dig +time=3 +tries=1 +short "@$srv" "$zone" SOA 2>/dev/null)"
    serial="$(echo "$soa" | awk '{print $3}')"
    if [ -z "$serial" ]; then echo "$srv  keine Antwort (Zeitueberschreitung, REFUSED oder Zone nicht geladen)"; abweichung=1; continue; fi
    echo "$srv  Seriennummer $serial"
    if [ -z "$erste" ]; then erste="$serial"; elif [ "$serial" != "$erste" ]; then abweichung=1; fi
done
if [ "$abweichung" -eq 0 ]; then echo "Ergebnis: alle Server haben dieselbe Seriennummer"; else echo "Ergebnis: Abweichung festgestellt"; exit 1; fi
