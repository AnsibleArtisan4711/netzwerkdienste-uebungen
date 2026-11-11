# norecurse und rekursiv im Vergleich

Zu Modul 11: [11-fehlersuche-und-monitoring](../11.1-fehlersuche-und-monitoring.md). Dort steht die ausführliche Anleitung.

## Ziel

Den Unterschied zwischen einer Abfrage mit und ohne Rekursion an einem Resolver erkennen (Kontrollfrage 3 des Lehrplans).

## Voraussetzungen

- SRV-LIN-BIND leitet `lab.internal` an `192.168.50.10` weiter (Modul 7).
- Ein leerer Cache: `rndc flush`.

## Schritte

1. Leere den Cache:

   ```bash
   sudo rndc flush
   ```

2. Frage **ohne** Rekursion:

   ```bash
   dig @192.168.50.11 testhost.lab.internal A +norecurse +noall +comments +answer
   ```

3. Frage **mit** Rekursion (Standard):

   ```bash
   dig @192.168.50.11 testhost.lab.internal A +noall +comments +answer
   ```

4. Wiederhole Schritt 2: Jetzt steht die Antwort im Cache.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# Lehrplan Kontrollfrage 3: +norecurse gegen einen Resolver (SRV-LIN-BIND, Name aus der weitergeleiteten Zone lab.internal)
$ rndc flush
$ dig @192.168.50.11 testhost.lab.internal A +norecurse +noall +comments +answer
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 37904
;; flags: qr ra; QUERY: 1, ANSWER: 0, AUTHORITY: 13, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 32ea24ffff42f061010000006af494f0543557a367007a1e (good)
$ dig @192.168.50.11 testhost.lab.internal A +noall +comments +answer   (Standard, rekursiv)
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 41303
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: d1438c3fd6e09ea6010000006af494f0e587de4c1e9b40fd (good)
;; ANSWER SECTION:
testhost.lab.internal.	3600	IN	A	192.168.50.120

$ dig @192.168.50.11 testhost.lab.internal A +norecurse +noall +comments +answer   (jetzt aus dem Cache)
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 21259
;; flags: qr ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 5af343a15eb282f3010000006af494f0989297003e43c484 (good)
;; ANSWER SECTION:
testhost.lab.internal.	3600	IN	A	192.168.50.120
```

## So liest du die Ausgabe

- Ohne Rekursion und mit leerem Cache: `ANSWER: 0`, die Autorität zeigt nur Hinweise (`AUTHORITY: 13`). Der Server fragt niemanden weiter.
- Mit Rekursion: `rd` ist gesetzt, die Antwort kommt (`192.168.50.120`) und landet im Cache.
- Danach liefert auch `+norecurse` die Antwort, nun aus dem **Cache**.
- Damit lässt sich beweisen, ob ein Server eine Antwort schon hat: Mit `+norecurse` prüfst du nur seinen Cache.

## Selbst ausprobieren

Warte die TTL ab oder leere den Cache und wiederhole Schritt 4.
