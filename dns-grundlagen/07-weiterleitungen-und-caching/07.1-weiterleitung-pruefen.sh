#!/bin/bash
# Uebung 07.1: Prueft die Weiterleitungen und das Cache-Verhalten. Aendert nichts (die Abfragen fuellen nur die Caches).
# Aufruf:  bash 07.1-weiterleitung-pruefen.sh
# Umgebungsvariablen: WIN (192.168.50.10), LIN (192.168.50.11)

WIN="${WIN:-192.168.50.10}"
LIN="${LIN:-192.168.50.11}"
fehler=0
ok()    { echo "OK      $1"; }
fehlt() { echo "FEHLT   $1"; fehler=$((fehler + 1)); }

antwort() { dig +time=3 +tries=1 +short "@$1" "$2" A 2>/dev/null | head -1; }
flags()   { dig +time=3 +tries=1 +noall +comments "@$1" "$2" A 2>/dev/null | grep -o 'flags: [a-z ]*;' ; }

# 1. Bedingte Weiterleitung auf Windows: richtige Adresse, aber nicht autoritativ (kein aa)
a="$(antwort "$WIN" portal.partner.example.net)"
if [ "$a" = "192.168.50.88" ]; then ok "WIN liefert portal.partner.example.net = $a"; else fehlt "WIN: portal.partner.example.net ergab '$a' (erwartet 192.168.50.88)"; fi
if flags "$WIN" portal.partner.example.net | grep -qw aa; then fehlt "WIN antwortet autoritativ (aa); die Zone sollte nur weitergeleitet sein, keine eigene Kopie"
else ok "WIN antwortet nicht autoritativ (kein aa-Flag)"; fi

# 2. Ursprungsserver antwortet autoritativ
if flags "$LIN" portal.partner.example.net | grep -qw aa; then ok "LIN antwortet autoritativ (aa)"; else fehlt "LIN antwortet nicht autoritativ"; fi

# 3. Weiterleitung in die andere Richtung: lab.internal ueber LIN (Teil 3)
b="$(antwort "$LIN" testhost.lab.internal)"
if [ "$b" = "192.168.50.120" ]; then ok "LIN liefert testhost.lab.internal = $b"
else fehlt "LIN: testhost.lab.internal ergab '$b' (erwartet 192.168.50.120; bei SERVFAIL siehe Hinweis zu validate-except)"; fi

# 4. Negatives Caching: TTL der NXDOMAIN-Antwort darf das SOA-Minimum nicht ueberschreiten
soa="$(dig +time=3 +tries=1 +short "@$LIN" partner.example.net SOA 2>/dev/null)"
min="$(echo "$soa" | awk 'NF == 7 {print $7}')"
ntl="$(dig +time=3 +tries=1 +noall +authority "@$WIN" nichtda-$$.partner.example.net A 2>/dev/null | awk '$4 == "SOA" {print $2; exit}')"
if [ -n "$min" ] && [ -n "$ntl" ] && [ "$ntl" -le "$min" ]; then ok "negative TTL $ntl <= SOA-Minimum $min"
else fehlt "negative TTL '$ntl', SOA-Minimum '$min'"; fi

echo
if [ "$fehler" -eq 0 ]; then echo "Ergebnis: alles in Ordnung"; else echo "Ergebnis: $fehler Pruefung(en) fehlgeschlagen"; exit 1; fi
