#!/bin/bash
# Uebung 06.1: Prueft auf SRV-LIN-BIND, ob die Zonenuebertragung in beide Richtungen funktioniert und
# unberechtigte Abzuege abgelehnt werden. Aendert nichts.
# Aufruf:  bash 06.1-transfer-pruefen.sh
# Umgebungsvariablen: WIN (192.168.50.10), LIN (192.168.50.11)

WIN="${WIN:-192.168.50.10}"
LIN="${LIN:-192.168.50.11}"
fehler=0
ok()    { echo "OK      $1"; }
fehlt() { echo "FEHLT   $1"; fehler=$((fehler + 1)); }

serial() { dig +time=2 +tries=1 +short "@$1" "$2" SOA 2>/dev/null | awk 'NF == 7 && $3 ~ /^[0-9]+$/ {print $3}'; }

# 1. Seriennummern: Sekundaerserver muss dieselbe Seriennummer wie der Primaerserver haben
vergleiche() {   # vergleiche Zone Primaer Sekundaer
    local p s
    p="$(serial "$2" "$1")"; s="$(serial "$3" "$1")"
    if [ -z "$p" ] || [ -z "$s" ]; then fehlt "$1: keine SOA-Antwort (Primaer '$p', Sekundaer '$s')"
    elif [ "$p" = "$s" ]; then ok "$1: Seriennummer gleich ($p)"
    else fehlt "$1: Primaer $p, Sekundaer $s (Transfer noch nicht erfolgt?)"; fi
}
vergleiche corp.example.com            "$WIN" "$LIN"
vergleiche 50.168.192.in-addr.arpa     "$WIN" "$LIN"
vergleiche branch.example.org          "$LIN" "$WIN"

# 2. Abzug durch einen unberechtigten Absender muss scheitern (hier: Absender ist dieser Server selbst
#    bzw. der Server, der nicht in allow-transfer steht)
abzug() {        # abzug Zone Server -> Anzahl Eintraege, 0 bei Ablehnung
    dig +time=3 +tries=1 "@$2" "$1" AXFR 2>/dev/null | grep -c 'XFR size'
}
if [ "$(abzug branch.example.org "$LIN")" = "0" ]; then ok "AXFR branch.example.org von diesem Rechner aus abgelehnt"
else fehlt "AXFR branch.example.org von diesem Rechner aus erlaubt (allow-transfer pruefen)"; fi

# 3. Nur kurzer Hinweis auf den Transferstatus der Sekundaerzonen
echo
rndc zonestatus corp.example.com 2>/dev/null | grep -E '^(type|serial|next refresh)' | sed 's/^/        /'

echo
if [ "$fehler" -eq 0 ]; then echo "Ergebnis: alles in Ordnung"; else echo "Ergebnis: $fehler Pruefung(en) fehlgeschlagen"; exit 1; fi
