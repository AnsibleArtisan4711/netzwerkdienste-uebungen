#!/bin/bash
# Uebung 11.1: Sammelt Diagnosedaten von SRV-LIN-BIND (nur lesend, nichts wird geaendert).
# Aufruf:  sudo bash 11.1-bind-diagnose.sh [zone]      (Standard: branch.example.org)
# Benoetigt rndc-Rechte (root oder Gruppe bind).

zone="${1:-branch.example.org}"
srv="${SRV:-192.168.50.11}"

echo "== Konfiguration"
named-checkconf && echo "named-checkconf: keine Fehler"
echo
echo "== Dienststatus"
rndc status | grep -E "version|running|debug level|query logging|number of zones|xfers"
echo
echo "== Zonenstatus ($zone)"
rndc zonestatus "$zone" | grep -E "name|type|serial|next refresh|expires|dynamic|frozen|secure"
echo
echo "== Antwort auf $srv: SOA, NS"
dig +time=3 +tries=1 +noall +comments +answer "@$srv" "$zone" SOA | grep -E "status|SOA"
dig +time=3 +tries=1 +short "@$srv" "$zone" NS
echo
echo "== Letzte Meldungen zu Transfers und Sicherheit (falls Logdateien vorhanden)"
for f in /var/log/named/transfers.log /var/log/named/security.log; do
    if [ -r "$f" ]; then echo "-- $f"; tail -5 "$f" | cut -c1-200; fi
done
