#!/usr/bin/env bash
# Uebung 03.1: Prueft den Zustand von BIND 9 auf SRV-LIN-BIND. Aendert nichts.
# Aufruf:  bash 03.1-bind-pruefen.sh
# Umgebungsvariablen (nur fuer Tests ausserhalb des Labors):
#   CONF=/pfad/zu/named.conf      (Standard: /etc/bind/named.conf)
#   RNDC_OPTS="-k /pfad/rndc.key" (Standard: leer, rndc benutzt /etc/bind/rndc.key)
#   SERVER=192.168.50.11          (Adresse fuer die Testabfrage)

CONF="${CONF:-/etc/bind/named.conf}"
RNDC_OPTS="${RNDC_OPTS:-}"
SERVER="${SERVER:-192.168.50.11}"
fehler=0

ok()    { echo "OK      $1"; }
fehlt() { echo "FEHLT   $1"; fehler=$((fehler + 1)); }
info()  { echo "INFO    $1"; }

# 1. Pakete (nur auf Systemen mit dpkg)
if command -v dpkg >/dev/null 2>&1; then
    for p in bind9 bind9utils bind9-dnsutils; do
        if dpkg -s "$p" >/dev/null 2>&1; then ok "Paket $p installiert"; else fehlt "Paket $p"; fi
    done
else
    info "dpkg nicht gefunden, Paketpruefung uebersprungen"
fi

# 2. Systembenutzer
if id bind >/dev/null 2>&1; then ok "Benutzer 'bind' vorhanden"; else fehlt "Benutzer 'bind'"; fi

# 3. Dienst (heisst je nach Version bind9 oder named)
if command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd/system ]; then
    aktiv=""
    for dienst in named bind9; do
        if systemctl is-active --quiet "$dienst" 2>/dev/null; then aktiv="$dienst"; fi
    done
    if [ -n "$aktiv" ]; then ok "Dienst '$aktiv' laeuft"; else fehlt "Dienst named/bind9 laeuft nicht"; fi
else
    info "systemd nicht aktiv, Dienstpruefung uebersprungen"
fi

# 4. Syntax der Konfiguration
if named-checkconf "$CONF" >/dev/null 2>&1; then ok "named-checkconf ohne Fehler"; else fehlt "named-checkconf meldet Fehler (named-checkconf $CONF)"; fi

# 5. ACL und Lauschadressen in der wirksamen Konfiguration
wirksam="$(named-checkconf -p "$CONF" 2>/dev/null)"
echo "$wirksam" | grep -q 'acl "lab-nets"' && ok "ACL lab-nets definiert" || fehlt "ACL lab-nets fehlt"
echo "$wirksam" | grep -q 'allow-query' && ok "allow-query gesetzt" || fehlt "allow-query fehlt"
echo "$wirksam" | grep -q 'listen-on ' && ok "listen-on gesetzt" || fehlt "listen-on fehlt"

# 6. Lauscht named auf Port 53 und 953?
if command -v ss >/dev/null 2>&1; then
    ss -tuln 2>/dev/null | grep -q ':53 ' && ok "Port 53 wird bedient" || fehlt "nichts lauscht auf Port 53"
    ss -tln  2>/dev/null | grep -q ':953 ' && ok "Port 953 (rndc) wird bedient" || fehlt "nichts lauscht auf Port 953"
fi

# 7. rndc und eine Testabfrage
# shellcheck disable=SC2086
if rndc $RNDC_OPTS status >/dev/null 2>&1; then ok "rndc status antwortet"; else fehlt "rndc status antwortet nicht"; fi
if dig +time=2 +tries=1 +norecurse "@$SERVER" localhost A +short 2>/dev/null | grep -q '127.0.0.1'; then
    ok "Testabfrage 'localhost' an $SERVER liefert 127.0.0.1"
else
    fehlt "Testabfrage 'localhost' an $SERVER liefert nichts"
fi

# 8. AppArmor-Profil (Ubuntu; auf anderen Systemen kann es fehlen)
if [ -e /etc/apparmor.d/usr.sbin.named ]; then ok "AppArmor-Profil usr.sbin.named vorhanden"; else info "kein AppArmor-Profil usr.sbin.named"; fi

echo
if [ "$fehler" -eq 0 ]; then echo "Ergebnis: alles in Ordnung"; else echo "Ergebnis: $fehler Pruefung(en) fehlgeschlagen"; exit 1; fi
