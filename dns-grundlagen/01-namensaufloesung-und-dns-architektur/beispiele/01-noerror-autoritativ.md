# NOERROR autoritativ

Zu Modul 01: [01-namensaufloesung-und-dns-architektur](../01.1-namensaufloesung-und-dns-architektur.md). Dort steht die ausführliche Anleitung.

## Ziel

Eine autoritative Antwort vollständig lesen können: Status, Flags und die vier Abschnitte der Antwort.

## Voraussetzungen

- Ein Server, der für `branch.example.org` zuständig ist (hier `192.168.50.11`), und ein Rechner mit `dig`.
- Der Mitschnitt stammt aus einer Testumgebung, nicht aus dem Labor der Übung. Die Adressen entsprechen aber dem Labor.

## Schritte

1. Frage den SOA-Eintrag der Zone beim zuständigen Server ab. `+norecurse` schaltet die Rekursion aus, der Server antwortet also nur aus eigenen Daten:

   ```bash
   dig @192.168.50.11 branch.example.org SOA +norecurse
   ```

2. Suche in der Zeile `->>HEADER<<-` den `status:` und in der Zeile darunter die `flags:`.
3. Lies den `ANSWER SECTION`-Block: Er enthält den SOA-Eintrag.
4. Sieh dir `AUTHORITY SECTION` und `ADDITIONAL SECTION` an: Dort stehen der Namenserver der Zone und seine Adresse.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
; Mitschnitt aus einer Testumgebung (Ubuntu 24.04, BIND 9.18.39), nicht aus dem Labor der Uebung.
; Befehl: dig @192.168.50.11 branch.example.org SOA +norecurse


; <<>> DiG 9.18.39-0ubuntu0.24.04.9-Ubuntu <<>> @192.168.50.11 branch.example.org SOA +norecurse
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 31999
;; flags: qr aa ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 054e929ee01e1329010000006af4856c6cbdadea19aecb25 (good)
;; QUESTION SECTION:
;branch.example.org.		IN	SOA

;; ANSWER SECTION:
branch.example.org.	3600	IN	SOA	linserver.branch.example.org. hostmaster.branch.example.org. 2026110801 900 300 604800 3600

;; AUTHORITY SECTION:
branch.example.org.	3600	IN	NS	linserver.branch.example.org.

;; ADDITIONAL SECTION:
linserver.branch.example.org. 3600 IN	A	192.168.50.11

;; Query time: 0 msec
;; SERVER: 192.168.50.11#53(192.168.50.11) (UDP)
;; WHEN: Wed Nov 11 16:10:36 CET 2026
;; MSG SIZE  rcvd: 162
```

## So liest du die Ausgabe

- `status: NOERROR`: Die Frage wurde beantwortet, der Name existiert.
- `flags: qr aa ra`: `qr` = Antwort, `aa` = der Server antwortet als **autoritativ** für die Zone, `ra` = der Server bietet Rekursion an. `rd` fehlt, weil `+norecurse` es nicht mitsendet.
- SOA-Daten in der Reihenfolge: Seriennummer `2026110801`, Refresh `900`, Retry `300`, Expire `604800`, Minimum `3600`.
- `AUTHORITY` nennt den Namenserver der Zone, `ADDITIONAL` gibt dessen Adresse gleich mit, damit keine weitere Abfrage nötig ist.
- `EDNS`/`COOKIE`/`MSG SIZE` sind technische Zusätze: EDNS erlaubt UDP-Pakete bis 1232 Byte, das Cookie schützt vor gefälschten Absendern.

## Selbst ausprobieren

Frage statt `SOA` den Typ `NS` ab und vergleiche die Abschnitte.
