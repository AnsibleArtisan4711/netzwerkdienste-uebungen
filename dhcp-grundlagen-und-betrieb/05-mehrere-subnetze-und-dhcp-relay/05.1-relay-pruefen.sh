#!/usr/bin/env bash
# Prueft das DHCP-Relay auf RTR-LIN (Uebung 05.1). Aendert nichts.
# Aufruf: ./05.1-relay-pruefen.sh
set -uo pipefail

datei=/etc/default/isc-dhcp-relay
fehler=0
ok()   { echo "[ok]    $*"; }
fehl() { echo "[FEHLT] $*"; fehler=1; }

[[ -r "$datei" ]] && ok "$datei vorhanden" || { fehl "$datei fehlt"; exit 1; }
# shellcheck disable=SC1090
source "$datei"

[[ -n "${SERVERS:-}" ]]    && ok "SERVERS=$SERVERS"       || fehl "SERVERS ist leer"
[[ -n "${INTERFACES:-}" ]] && ok "INTERFACES=$INTERFACES" || fehl "INTERFACES ist leer"

for i in ${INTERFACES:-}; do
    ip link show "$i" >/dev/null 2>&1 && ok "Schnittstelle $i vorhanden" || fehl "Schnittstelle $i existiert nicht"
done

[[ "$(cat /proc/sys/net/ipv4/ip_forward)" == "1" ]] && ok "ip_forward = 1" || fehl "ip_forward ist nicht 1"

if systemctl is-active --quiet isc-dhcp-relay; then
    ok "Dienst isc-dhcp-relay laeuft"
else
    fehl "Dienst isc-dhcp-relay laeuft nicht (journalctl -u isc-dhcp-relay -n 30)"
fi

for s in ${SERVERS:-}; do
    if ip route get "$s" >/dev/null 2>&1; then
        ok "Route zu $s vorhanden: $(ip route get "$s" | head -1)"
    else
        fehl "keine Route zu $s"
    fi
done
exit "$fehler"
