#!/bin/bash
# Uebung 05.1: Prueft auf SRV-LIN-BIND die Eintraege der Zone branch.example.org. Aendert nichts.
# Aufruf:  bash 05.1-records-pruefen.sh
# Umgebungsvariablen: SERVER (192.168.50.11), ZONE (branch.example.org), ZONEFILE (/etc/bind/db.branch.example.org)

SERVER="${SERVER:-192.168.50.11}"
ZONE="${ZONE:-branch.example.org}"
ZONEFILE="${ZONEFILE:-/etc/bind/db.$ZONE}"
fehler=0

# pruefe "Beschreibung" "Name" "Typ" "erwartete Antwort (dig +short, erste Zeile)"
pruefe() {
    local text="$1" name="$2" typ="$3" erwartet="$4"
    local ist
    ist="$(dig +time=2 +tries=1 +short "@$SERVER" "$name" "$typ" 2>/dev/null | head -1)"
    if [ "$ist" = "$erwartet" ]; then
        echo "OK      $text: $ist"
    else
        echo "FEHLT   $text: erwartet '$erwartet', erhalten '$ist'"
        fehler=$((fehler + 1))
    fi
}

if named-checkzone -q "$ZONE" "$ZONEFILE"; then echo "OK      named-checkzone ($ZONEFILE)"; else echo "FEHLT   named-checkzone meldet Fehler"; fehler=$((fehler + 1)); fi

pruefe "A     linserver" "linserver.$ZONE" A     "192.168.50.11"
pruefe "AAAA  linserver" "linserver.$ZONE" AAAA  "fd00:50::11"
pruefe "A     web"       "web.$ZONE"       A     "192.168.50.40"
pruefe "AAAA  web"       "web.$ZONE"       AAAA  "fd00:50::40"
pruefe "CNAME www"       "www.$ZONE"       CNAME "web.$ZONE."
pruefe "MX    Apex"      "$ZONE"           MX    "10 linserver.$ZONE."
pruefe "TXT   Apex"      "$ZONE"           TXT   '"v=spf1 mx -all"'
pruefe "SRV   _ldap._tcp" "_ldap._tcp.$ZONE" SRV "10 100 389 linserver.$ZONE."

echo
if [ "$fehler" -eq 0 ]; then echo "Ergebnis: alles in Ordnung"; else echo "Ergebnis: $fehler Pruefung(en) fehlgeschlagen"; exit 1; fi
