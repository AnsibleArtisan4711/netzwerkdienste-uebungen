#!/usr/bin/env bash
# Uebung 11.1: zeigt, welche DHCP-Server in einem Mitschnitt OFFER/ACK senden (Option 54, Server-ID).
# Live:   sudo ./11.1-rogue-erkennen.sh -i net-b -t 60 -e "192.168.10.11 192.168.10.21"
# Datei:  ./11.1-rogue-erkennen.sh -f mitschnitt.txt -e "192.168.10.11"   (Ausgabe von tcpdump -nvv, als Text)
# -e: Liste der ERLAUBTEN Server-IDs (mit Leerzeichen getrennt). Alles andere wird als "UNBEKANNT" markiert.
set -eu
IFACE=""; SEK=60; ERLAUBT=""; DATEI=""
while getopts "i:t:e:f:" o; do
  case "$o" in
    i) IFACE="$OPTARG";; t) SEK="$OPTARG";; e) ERLAUBT="$OPTARG";; f) DATEI="$OPTARG";;
    *) echo "Aufruf: $0 (-i Schnittstelle [-t Sekunden] | -f Textdatei) [-e \"erlaubte IDs\"]" >&2; exit 2;;
  esac
done
if [ -z "$IFACE" ] && [ -z "$DATEI" ]; then echo "Schnittstelle (-i) oder Datei (-f) angeben." >&2; exit 2; fi

quelle() {
  if [ -n "$DATEI" ]; then cat "$DATEI"
  else timeout "$SEK" tcpdump -l -nvvi "$IFACE" 'udp and (port 67 or port 68)' 2>/dev/null || true
  fi
}

printf '%-18s %-6s %-8s %s\n' Server-ID Typ Anzahl Bewertung
quelle | awk -v erlaubt="$ERLAUBT" '
  BEGIN { n = split(erlaubt, a, " "); for (i = 1; i <= n; i++) ok[a[i]] = 1 }
  /^[0-9]/                         { typ = "" }
  /DHCP-Message \(53\)/            { typ = $NF }
  /Server-ID \(54\)/ && (typ == "Offer" || typ == "ACK" || typ == "NACK") {
      z[$NF " " typ]++ }
  END {
      for (k in z) { split(k, p, " ");
          printf "%-18s %-6s %-8d %s\n", p[1], p[2], z[k], (p[1] in ok) ? "erlaubt" : "UNBEKANNT" }
      if (length(z) == 0) print "(keine OFFER/ACK-Pakete gesehen)"
  }' | sort
