# dig: Reverse-Abfrage

Zu Modul 11: [11-fehlersuche-und-monitoring](../11.1-fehlersuche-und-monitoring.md). Dort steht die ausführliche Anleitung.

## Ziel

Eine Reverse-Abfrage (PTR) mit `dig -x` durchführen und lesen.

## Voraussetzungen

- Die Reverse-Zone `50.168.192.in-addr.arpa` ist auf `192.168.50.10` eingerichtet (Modul 5).
- Stellvertreter für Windows wie im vorigen Beispiel.

## Schritte

1. Frage den Namen zu einer Adresse ab:

   ```bash
   dig @192.168.50.10 -x 192.168.50.10
   ```

2. Lies im Abschnitt `QUESTION` den Namen, den `dig` selbst gebildet hat.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus. Der Windows-Server wurde im Test durch eine zweite BIND-Instanz ersetzt. **Echte Windows-Ausgaben können abweichen.**

```text
$ dig @192.168.50.10 -x 192.168.50.10

; <<>> DiG 9.18.39-0ubuntu0.24.04.9-Ubuntu <<>> @192.168.50.10 -x 192.168.50.10
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 26143
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: ecdb441b3573c4b5010000006af494e9484d58b49258f49c (good)
;; QUESTION SECTION:
;10.50.168.192.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
10.50.168.192.in-addr.arpa. 3600 IN	PTR	winserver.corp.example.com.

;; Query time: 0 msec
;; SERVER: 192.168.50.10#53(192.168.50.10) (UDP)
;; WHEN: Wed Nov 11 17:16:41 CET 2026
;; MSG SIZE  rcvd: 123
```

## So liest du die Ausgabe

- `10.50.168.192.in-addr.arpa` ist die Adresse rückwärts, `PTR` liefert `winserver.corp.example.com.`.
- Fehlt der PTR, kommt `NXDOMAIN`. Typisch bei Reverse-Problemen: Die Reverse-Zone fehlt oder der Eintrag ist nicht angelegt.

## Selbst ausprobieren

Frage dieselbe Adresse beim zweiten Server ab und vergleiche das Ergebnis.
