#!/usr/bin/env bash
# Uebung 01.1: Prueft auf SRV-LIN-BIND, ob Adresse, Name und Namensaufloesung wie erwartet eingestellt sind.
# Aufruf: bash 01.1-labor-pruefen.sh
# Aendert nichts am System. Ausgabe: OK oder FEHLT je Pruefung.

erwartet_v4="192.168.50.11"
erwartet_v6="fd00:50::11"
erwartet_name="srv-lin-bind"

pruefe() {            # pruefe "Beschreibung" befehl...
    local text="$1"; shift
    if "$@" >/dev/null 2>&1; then echo "OK     $text"; else echo "FEHLT  $text"; fi
}

pruefe "IPv4-Adresse $erwartet_v4 gesetzt"  bash -c "ip -4 -br addr | grep -q '$erwartet_v4/24'"
pruefe "IPv6-Adresse $erwartet_v6 gesetzt"  bash -c "ip -6 -br addr | grep -qi '$erwartet_v6/64'"
pruefe "Rechnername $erwartet_name"          bash -c "[ \"\$(hostname -s)\" = '$erwartet_name' ]"
pruefe "dig vorhanden (bind9-dnsutils)"      command -v dig
pruefe "Windows-Server erreichbar (192.168.50.10)" ping -c 1 -W 2 192.168.50.10
pruefe "Client erreichbar (192.168.50.100)"  ping -c 1 -W 2 192.168.50.100

echo
echo "Reihenfolge der Namensaufloesung (hosts-Zeile in /etc/nsswitch.conf):"
grep '^hosts:' /etc/nsswitch.conf
echo
echo "Eintraege in /etc/hosts mit dem Uebungsmarker (sollten nach Teil 1 fehlen):"
grep -n 'dns-uebung-01.1' /etc/hosts || echo "  keine"
