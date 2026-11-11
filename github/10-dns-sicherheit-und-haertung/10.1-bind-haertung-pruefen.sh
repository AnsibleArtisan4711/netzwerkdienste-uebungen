#!/bin/bash
# Uebung 10.1: Prueft die Haertung von SRV-LIN-BIND von aussen (nur lesende Abfragen).
# Aufruf:  bash 10.1-bind-haertung-pruefen.sh
# Umgebungsvariablen: SRV (192.168.50.11), DMZ_SRV (192.168.60.11), INT_SRC (192.168.50.100), DMZ_SRC (192.168.60.100)
# Die Quelladressen muessen auf dem Rechner vorhanden sein (dig -b); auf CLI-TEST-01 entfaellt -b, siehe md.

SRV="${SRV:-192.168.50.11}"; DMZ_SRV="${DMZ_SRV:-192.168.60.11}"
INT_SRC="${INT_SRC:-192.168.50.100}"; DMZ_SRC="${DMZ_SRC:-192.168.60.100}"
fehler=0
ok()    { echo "OK      $1"; }
fehlt() { echo "FEHLT   $1"; fehler=$((fehler + 1)); }
status() { grep -o 'status: [A-Z]*' | head -1; }

v="$(dig -b "$INT_SRC" +time=3 +tries=1 +short "@$SRV" version.bind CHAOS TXT 2>/dev/null)"
if [ "$v" = '"unavailable"' ]; then ok "version.bind liefert $v"; else fehlt "version.bind liefert '$v' (erwartet \"unavailable\")"; fi

s="$(dig -b "$DMZ_SRC" +time=3 +tries=1 +noall +comments "@$DMZ_SRV" www.example.com A 2>/dev/null | status)"
if [ "$s" = "status: REFUSED" ]; then ok "kein offener Resolver: rekursive Anfrage aus der DMZ ergibt $s"; else fehlt "rekursive Anfrage aus der DMZ ergab '$s' (erwartet REFUSED)"; fi

s="$(dig -b "$INT_SRC" +time=3 +tries=1 +noall +comments "@$SRV" partner.example.net AXFR 2>/dev/null | grep -c 'Transfer failed')"
if [ "$s" -ge 1 ]; then ok "AXFR von partner.example.net aus dem Labornetz ist gesperrt"; else fehlt "AXFR von partner.example.net wurde ausgeliefert"; fi

a="$(dig -b "$DMZ_SRC" +time=3 +tries=1 +short +norecurse "@$DMZ_SRV" branch.example.org SOA 2>/dev/null)"
if [ -n "$a" ]; then ok "autoritative Antwort fuer branch.example.org aus der DMZ bleibt moeglich"; else fehlt "keine autoritative Antwort aus der DMZ"; fi

echo
if [ "$fehler" -eq 0 ]; then echo "Ergebnis: alles in Ordnung"; else echo "Ergebnis: $fehler Pruefung(en) fehlgeschlagen"; exit 1; fi
