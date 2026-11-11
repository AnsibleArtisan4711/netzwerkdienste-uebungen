# Offener Resolver und AXFR

Zu Modul 10: [10-dns-sicherheit-und-haertung](../10.1-dns-sicherheit-und-haertung.md). Dort steht die ausführliche Anleitung.

## Ziel

Prüfen, dass der Server kein offener Resolver ist und wer eine Zone herunterladen darf, noch **vor** der globalen Sperre.

## Voraussetzungen

- Der DMZ-Zugang aus Modul 9 (`192.168.60.11`) und die Härtung `allow-recursion { lab-nets; };` aus Modul 10.
- Im Beispiel gilt noch der Standard von BIND für Zonentransfers: Alle dürfen, soweit eine Zone nichts anderes festlegt.

## Schritte

1. Frage von **außen** (DMZ-Quelle) eine rekursive Abfrage für einen fremden Namen:

   ```bash
   dig -b 192.168.60.100 @192.168.60.11 www.example.com A
   ```

2. Frage dort einen Namen aus der **eigenen** Zone, ohne Rekursion:

   ```bash
   dig -b 192.168.60.100 @192.168.60.11 branch.example.org SOA +norecurse
   ```

3. Frage aus dem Labornetz:

   ```bash
   dig -b 192.168.50.100 @192.168.50.11 corp.example.com SOA +short
   ```

4. Versuche Zonenabzüge von verschiedenen Absendern:

   ```bash
   dig -b 192.168.60.100 @192.168.60.11 branch.example.org AXFR
   dig -b 192.168.50.100 @192.168.50.11 partner.example.net AXFR
   dig @192.168.50.11 corp.example.com AXFR
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# Offener Resolver? Rekursive Anfrage von aussen (DMZ-Quelle) und aus dem Labornetz
$ dig -b 192.168.60.100 @192.168.60.11 www.example.com A
;; ->>HEADER<<- opcode: QUERY, status: REFUSED, id: 26055
;; flags: qr rd; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1
; EDNS: version: 0, flags:; udp: 1232
$ dig -b 192.168.60.100 @192.168.60.11 branch.example.org SOA +norecurse   (autoritativ, erlaubt)
linserver.branch.example.org. hostmaster.branch.example.org. 2026111112 900 300 604800 3600
$ dig -b 192.168.50.100 @192.168.50.11 corp.example.com SOA +short
winserver.corp.example.com. hostmaster.corp.example.com. 2026111103 900 300 604800 3600
# Zonentransfer ohne Berechtigung (Zustand VOR der globalen Sperre; Standard ist: alle duerfen)
$ dig -b 192.168.60.100 @192.168.60.11 branch.example.org AXFR
; Transfer failed.
$ dig -b 192.168.50.100 @192.168.50.11 partner.example.net AXFR
;; XFR size: 5 records (messages 1, bytes 248)
$ dig @192.168.50.11 corp.example.com AXFR  (lokal)
;; XFR size: 15 records (messages 1, bytes 514)
```

## So liest du die Ausgabe

- Von außen: `REFUSED` für den fremden Namen. Der Server arbeitet **nicht** als offener Resolver.
- Autoritative Daten der eigenen Zone bleiben erreichbar. Das ist gewollt.
- `branch.example.org` verweigert den Abzug (`allow-transfer` ist dort gesetzt). `partner.example.net` und `corp.example.com` liefern ihre Zone aus (5 bzw. 15 Einträge): Ohne `allow-transfer` gilt der Standard, **alle dürfen**.
- Das zeigt die Lücke, die das nächste Beispiel mit `allow-transfer { none; };` schließt.

## Selbst ausprobieren

Zähle in deiner Konfiguration, welche Zonen noch kein `allow-transfer` haben.
