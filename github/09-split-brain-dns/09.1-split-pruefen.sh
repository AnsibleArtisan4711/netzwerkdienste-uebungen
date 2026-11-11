#!/bin/bash
# Uebung 09.1: Prueft auf SRV-LIN-BIND bzw. CLI-Linux, ob beide Subnetze die erwarteten Antworten bekommen.
# Aendert nichts. Aufruf:  bash 09.1-split-pruefen.sh [ansicht]   (ansicht = views oder ohne; Standard: views)
# Umgebungsvariablen: INT_SRV (192.168.50.11), DMZ_SRV (192.168.60.11), INT_SRC (192.168.50.100), DMZ_SRC (192.168.60.100)
# Wichtig: Die Quelladressen muessen auf dem Rechner vorhanden sein (dig -b).

INT_SRV="${INT_SRV:-192.168.50.11}"; DMZ_SRV="${DMZ_SRV:-192.168.60.11}"
INT_SRC="${INT_SRC:-192.168.50.100}"; DMZ_SRC="${DMZ_SRC:-192.168.60.100}"
modus="${1:-views}"
fehler=0
ok()    { echo "OK      $1"; }
fehlt() { echo "FEHLT   $1"; fehler=$((fehler + 1)); }

a() { dig -b "$1" +time=3 +tries=1 +short "@$2" "$3" A 2>/dev/null | tail -1; }

i="$(a "$INT_SRC" "$INT_SRV" www.branch.example.org)"
d="$(a "$DMZ_SRC" "$DMZ_SRV" www.branch.example.org)"
if [ "$i" = "192.168.50.40" ]; then ok "intern: www.branch.example.org = $i"; else fehlt "intern: '$i' (erwartet 192.168.50.40)"; fi
if [ "$modus" = "views" ]; then
    if [ "$d" = "192.168.60.40" ]; then ok "DMZ: www.branch.example.org = $d"; else fehlt "DMZ: '$d' (erwartet 192.168.60.40)"; fi
    st="$(dig -b "$DMZ_SRC" +time=3 +tries=1 +noall +comments "@$DMZ_SRV" corp.example.com SOA 2>/dev/null | grep -o 'status: [A-Z]*')"
    if [ "$st" = "status: REFUSED" ]; then ok "DMZ: interne Zone corp.example.com wird nicht ausgeliefert ($st)"; else fehlt "DMZ: corp.example.com ergab '$st' (erwartet REFUSED)"; fi
else
    if [ "$d" = "192.168.50.40" ]; then ok "ohne Views antwortet auch die .60-Adresse mit $d"; else fehlt "DMZ ohne Views: '$d' (erwartet 192.168.50.40)"; fi
fi
echo
if [ "$fehler" -eq 0 ]; then echo "Ergebnis: alles in Ordnung"; else echo "Ergebnis: $fehler Pruefung(en) fehlgeschlagen"; exit 1; fi
