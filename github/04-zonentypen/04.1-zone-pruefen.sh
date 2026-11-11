#!/usr/bin/env bash
# Uebung 04.1: Prueft die Zonendatei und die Antwort des Servers fuer branch.example.org. Aendert nichts.
# Aufruf:  bash 04.1-zone-pruefen.sh
# Umgebungsvariablen: ZONE (branch.example.org), ZONEFILE (/etc/bind/db.branch.example.org), SERVER (192.168.50.11)

ZONE="${ZONE:-branch.example.org}"
ZONEFILE="${ZONEFILE:-/etc/bind/db.$ZONE}"
SERVER="${SERVER:-192.168.50.11}"
fehler=0
ok()    { echo "OK      $1"; }
fehlt() { echo "FEHLT   $1"; fehler=$((fehler + 1)); }

# 1. Syntax der Zonendatei
if named-checkzone -q "$ZONE" "$ZONEFILE"; then ok "named-checkzone ohne Fehler ($ZONEFILE)"; else fehlt "named-checkzone meldet Fehler"; fi

# 2. SOA vom Server
soa="$(dig +time=2 +tries=1 +short "@$SERVER" "$ZONE" SOA 2>/dev/null)"
if [ -n "$soa" ]; then ok "Server antwortet mit SOA: $soa"; else fehlt "keine SOA-Antwort von $SERVER"; fi

# 3. Seriennummer im Format JJJJMMTTnn (10 Ziffern, plausibles Datum)
serial="$(echo "$soa" | awk '{print $3}')"
if echo "$serial" | grep -Eq '^20[0-9]{2}(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])[0-9]{2}$'; then
    ok "Seriennummer $serial hat das Format JJJJMMTTnn"
else
    fehlt "Seriennummer '$serial' hat nicht das Format JJJJMMTTnn"
fi

# 4. Datei und Server haben dieselbe Seriennummer (Zonendatei wurde geladen)
datei_serial="$(named-checkzone "$ZONE" "$ZONEFILE" 2>/dev/null | sed -n 's/.*loaded serial \([0-9]*\).*/\1/p')"
if [ -n "$datei_serial" ] && [ "$datei_serial" = "$serial" ]; then
    ok "Seriennummer in Datei und Server gleich ($serial)"
else
    fehlt "Seriennummer: Datei '$datei_serial', Server '$serial' (rndc reload vergessen?)"
fi

# 5. NS-Eintrag und seine Adresse
ns="$(dig +time=2 +tries=1 +short "@$SERVER" "$ZONE" NS 2>/dev/null | head -1)"
if [ -n "$ns" ]; then
    ok "NS-Eintrag: $ns"
    a="$(dig +time=2 +tries=1 +short "@$SERVER" "$ns" A 2>/dev/null | head -1)"
    if [ -n "$a" ]; then ok "NS-Name hat A-Eintrag: $a"; else fehlt "NS-Name $ns hat keinen A-Eintrag"; fi
else
    fehlt "kein NS-Eintrag"
fi

# 6. Antwort ist autoritativ (Flag aa)
if dig +time=2 +tries=1 "@$SERVER" "$ZONE" SOA 2>/dev/null | grep -Eq '^;; flags:.* aa'; then ok "Antwort traegt das Flag aa"; else fehlt "Flag aa fehlt"; fi

echo
if [ "$fehler" -eq 0 ]; then echo "Ergebnis: alles in Ordnung"; else echo "Ergebnis: $fehler Pruefung(en) fehlgeschlagen"; exit 1; fi
