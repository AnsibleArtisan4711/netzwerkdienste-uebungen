#!/bin/bash
# Uebung 12.1: Abnahmetest fuer die AlpenTech-Zonen hq.alpentech.internal und dev.alpentech.internal (nur lesend).
# Aufruf:  bash 12.1-abnahme-pruefen.sh [server ...]        (Standard: beide Server, 192.168.50.10 und 192.168.50.11)
# Pruefung je Server: Vorwaerts (A, AAAA, CNAME, MX, TXT, SRV), Rueckwaerts (PTR IPv4 und IPv6), Seriennummern, gesperrter Zonentransfer.
# Umgebungsvariable SRC: Quelladresse fuer dig -b (Standard leer = keine). Beispiel: SRC=192.168.50.100 bash 12.1-abnahme-pruefen.sh
# Ergebnis: Ausgabe "OK" oder "FEHLT" je Zeile, Rueckgabewert 1 bei mindestens einem Fehler.

if [ "$#" -gt 0 ]; then SERVER=("$@"); else SERVER=(192.168.50.10 192.168.50.11); fi
B=""; [ -n "$SRC" ] && B="-b $SRC"
fehler=0; ok=0

frage() { dig $B +time=3 +tries=1 +short "@$1" "$2" "$3" 2>/dev/null | grep -v '^;' | sort | tr '\n' ' ' | sed 's/ $//'; }
pruefe() {   # server name typ erwartet
    local ist; ist="$(frage "$1" "$2" "$3")"
    if [ "$ist" = "$4" ]; then ok=$((ok + 1)); else echo "FEHLT   $1  $3 $2  erwartet '$4'  erhalten '$ist'"; fehler=$((fehler + 1)); fi
}

for s in "${SERVER[@]}"; do
    echo "== Server $s"
    # Vorwaerts
    pruefe "$s" ns1.hq.alpentech.internal   A    192.168.50.10
    pruefe "$s" fs01.hq.alpentech.internal  A    192.168.50.51
    pruefe "$s" mail.hq.alpentech.internal  A    192.168.50.52
    pruefe "$s" erp.hq.alpentech.internal   A    192.168.50.53
    pruefe "$s" ns1.dev.alpentech.internal  A    192.168.50.11
    pruefe "$s" git.dev.alpentech.internal  A    192.168.50.61
    pruefe "$s" ci.dev.alpentech.internal   A    192.168.50.62
    pruefe "$s" build.dev.alpentech.internal A   192.168.50.63
    pruefe "$s" ns1.hq.alpentech.internal   AAAA fd00:50::10
    pruefe "$s" fs01.hq.alpentech.internal  AAAA fd00:50::51
    pruefe "$s" mail.hq.alpentech.internal  AAAA fd00:50::52
    pruefe "$s" erp.hq.alpentech.internal   AAAA fd00:50::53
    pruefe "$s" ns1.dev.alpentech.internal  AAAA fd00:50::11
    pruefe "$s" git.dev.alpentech.internal  AAAA fd00:50::61
    pruefe "$s" ci.dev.alpentech.internal   AAAA fd00:50::62
    pruefe "$s" build.dev.alpentech.internal AAAA fd00:50::63
    pruefe "$s" intranet.hq.alpentech.internal CNAME fs01.hq.alpentech.internal.
    pruefe "$s" wiki.dev.alpentech.internal    CNAME git.dev.alpentech.internal.
    pruefe "$s" hq.alpentech.internal  MX  "10 mail.hq.alpentech.internal."
    pruefe "$s" dev.alpentech.internal MX  "10 mail.hq.alpentech.internal."
    pruefe "$s" hq.alpentech.internal  TXT '"v=spf1 mx -all"'
    pruefe "$s" dev.alpentech.internal TXT '"v=spf1 -all"'
    pruefe "$s" _ldap._tcp.hq.alpentech.internal SRV "0 100 389 ns1.hq.alpentech.internal."
    pruefe "$s" _git._tcp.dev.alpentech.internal SRV "10 100 22 git.dev.alpentech.internal."
    # Rueckwaerts IPv4
    for p in "51 fs01.hq" "52 mail.hq" "53 erp.hq" "61 git.dev" "62 ci.dev" "63 build.dev"; do
        set -- $p
        pruefe "$s" "$1.50.168.192.in-addr.arpa" PTR "$2.alpentech.internal."
    done
    # Rueckwaerts IPv6 (16 Nibbles Zonenanteil in der Zone, 16 Nibbles Hostanteil im Namen)
    for p in "51 fs01.hq" "52 mail.hq" "53 erp.hq" "61 git.dev" "62 ci.dev" "63 build.dev"; do
        set -- $p
        n="$(printf '%016x' "0x$1" | rev | sed 's/./&./g; s/\.$//')"
        pruefe "$s" "$n.0.0.0.0.0.0.0.0.0.5.0.0.0.0.d.f.ip6.arpa" PTR "$2.alpentech.internal."
    done
    # Seriennummern und Zonentransfer
    for z in hq.alpentech.internal dev.alpentech.internal; do
        sn="$(dig $B +time=3 +tries=1 +short "@$s" "$z" SOA 2>/dev/null | grep -v '^;' | awk '{print $3}')"
        if [ -n "$sn" ]; then echo "INFO    Seriennummer $z auf $s: $sn"; else echo "FEHLT   $s  keine SOA fuer $z"; fehler=$((fehler + 1)); fi
        [ -z "$sn" ] && continue   # ohne Antwort ist ein gesperrter Transfer kein Nachweis
        if dig $B +time=3 +tries=1 "@$s" "$z" AXFR 2>/dev/null | grep -q "XFR size"; then
            echo "FEHLT   $s  AXFR fuer $z ist von dieser Adresse aus moeglich (soll gesperrt sein, ausser vom Partner)"; fehler=$((fehler + 1))
        else ok=$((ok + 1)); fi
    done
done
echo
echo "Bestanden: $ok   Fehler: $fehler"
if [ "$fehler" -eq 0 ]; then echo "Ergebnis: alles in Ordnung"; else echo "Ergebnis: $fehler Pruefung(en) fehlgeschlagen"; exit 1; fi
