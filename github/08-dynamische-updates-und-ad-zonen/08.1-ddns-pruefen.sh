#!/bin/bash
# Uebung 08.1: Prueft auf SRV-LIN-BIND die Einrichtung der dynamischen Updates (TSIG, Zonendatei in /var/lib/bind,
# Journal). Legt zum Test einen Eintrag an und loescht ihn wieder (ddns-test.branch.example.org).
# Aufruf:  sudo bash 08.1-ddns-pruefen.sh        (braucht Leserechte auf ddns.key und rndc)
# Umgebungsvariablen: ZONE (branch.example.org), SERVER (192.168.50.11), KEY (/etc/bind/ddns.key)

ZONE="${ZONE:-branch.example.org}"
SERVER="${SERVER:-192.168.50.11}"
KEY="${KEY:-/etc/bind/ddns.key}"
fehler=0
ok()    { echo "OK      $1"; }
fehlt() { echo "FEHLT   $1"; fehler=$((fehler + 1)); }

# 1. Schluesseldatei: vorhanden, Modus 640, Gruppe bind
if [ -f "$KEY" ]; then
    modus="$(stat -c '%a' "$KEY")"; gruppe="$(stat -c '%G' "$KEY")"
    if [ "$modus" = "640" ] && [ "$gruppe" = "bind" ]; then ok "$KEY: Modus $modus, Gruppe $gruppe"
    else fehlt "$KEY: Modus $modus, Gruppe $gruppe (erwartet 640 und bind)"; fi
else
    fehlt "$KEY fehlt (tsig-keygen -a hmac-sha256 ddns-key)"
fi

# 2. Zone ist dynamisch und liegt unter /var/lib/bind
status="$(rndc zonestatus "$ZONE" 2>&1)"
if echo "$status" | grep -q '^dynamic: yes'; then ok "Zone $ZONE ist dynamisch"; else fehlt "Zone $ZONE ist nicht dynamisch (allow-update bzw. update-policy fehlt?)"; fi
if echo "$status" | grep -q '^files: /var/lib/bind/'; then ok "Zonendatei liegt unter /var/lib/bind"; else fehlt "Zonendatei liegt nicht unter /var/lib/bind: $(echo "$status" | grep '^files:')"; fi
if echo "$status" | grep -q '^frozen: yes'; then fehlt "Zone ist eingefroren (rndc thaw $ZONE vergessen?)"; else ok "Zone ist nicht eingefroren"; fi

# 3. Update mit Schluessel funktioniert, ohne Schluessel wird es abgelehnt
nsupdate -k "$KEY" <<EOF >/dev/null 2>&1
server $SERVER
zone $ZONE
update add ddns-test.$ZONE 60 A 192.168.50.99
send
EOF
sleep 1
if [ "$(dig +short "@$SERVER" "ddns-test.$ZONE" A)" = "192.168.50.99" ]; then ok "Update mit Schluessel hat ddns-test.$ZONE angelegt"; else fehlt "Update mit Schluessel hat nicht funktioniert"; fi

if nsupdate <<EOF >/dev/null 2>&1
server $SERVER
zone $ZONE
update add ddns-test2.$ZONE 60 A 192.168.50.98
send
EOF
then fehlt "Update OHNE Schluessel wurde angenommen (allow-update zu offen?)"; else ok "Update ohne Schluessel abgelehnt"; fi

# 4. Aufraeumen
nsupdate -k "$KEY" <<EOF >/dev/null 2>&1
server $SERVER
zone $ZONE
update delete ddns-test.$ZONE A
update delete ddns-test2.$ZONE A
send
EOF
sleep 1
if [ -z "$(dig +short "@$SERVER" "ddns-test.$ZONE" A)" ]; then ok "Testeintrag wieder geloescht"; else fehlt "Testeintrag ddns-test.$ZONE ist noch vorhanden"; fi

echo
if [ "$fehler" -eq 0 ]; then echo "Ergebnis: alles in Ordnung"; else echo "Ergebnis: $fehler Pruefung(en) fehlgeschlagen"; exit 1; fi
