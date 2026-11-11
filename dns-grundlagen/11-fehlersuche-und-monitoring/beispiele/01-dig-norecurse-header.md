# dig: norecurse und Header

Zu Modul 11: [11-fehlersuche-und-monitoring](../11.1-fehlersuche-und-monitoring.md). Dort steht die ausführliche Anleitung.

## Ziel

Mit `dig` gezielt einen Server befragen und die Antwort Zeile für Zeile lesen.

## Voraussetzungen

- `corp.example.com` ist auf dem Windows-Server (`192.168.50.10`) eingerichtet.
- Im Test antwortete eine BIND-Instanz als Stellvertreter für SRV-WIN-DNS. Windows formatiert manche Angaben anders.

## Schritte

1. Frage den Server direkt, ohne Rekursion:

   ```bash
   dig @192.168.50.10 files.corp.example.com A +norecurse
   ```

2. Lies der Reihe nach: `status`, `flags`, Zähler (`QUERY`, `ANSWER`, `AUTHORITY`, `ADDITIONAL`), dann die Abschnitte.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus. Der Windows-Server wurde im Test durch eine zweite BIND-Instanz ersetzt. **Echte Windows-Ausgaben können abweichen.**

```text
$ dig @192.168.50.10 files.corp.example.com A +norecurse

; <<>> DiG 9.18.39-0ubuntu0.24.04.9-Ubuntu <<>> @192.168.50.10 files.corp.example.com A +norecurse
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 39301
;; flags: qr aa ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: b7a4d2535a4221ff010000006af494e966b4db5400e286c4 (good)
;; QUESTION SECTION:
;files.corp.example.com.		IN	A

;; ANSWER SECTION:
files.corp.example.com.	3600	IN	A	192.168.50.20

;; AUTHORITY SECTION:
corp.example.com.	3600	IN	NS	linserver.branch.example.org.
corp.example.com.	3600	IN	NS	winserver.corp.example.com.

;; ADDITIONAL SECTION:
winserver.corp.example.com. 3600 IN	A	192.168.50.10
winserver.corp.example.com. 3600 IN	AAAA	fd00:50::10

;; Query time: 0 msec
;; SERVER: 192.168.50.10#53(192.168.50.10) (UDP)
;; WHEN: Wed Nov 11 17:16:41 CET 2026
;; MSG SIZE  rcvd: 205
```

## So liest du die Ausgabe

- `status: NOERROR` und `aa`: Der Server antwortet autoritativ aus seiner Zone.
- `ANSWER: 1`: die Adresse `192.168.50.20`. In der Autorität stehen die beiden Namenserver der Zone (Windows und BIND) und im Zusatzteil ihre Adressen.
- Mit `@server` fragst du **diesen Server** und nicht den eingestellten Resolver. Das ist der erste Schritt bei jeder Fehlersuche.

## Selbst ausprobieren

Frage den anderen Namenserver der Zone ab und vergleiche die Seriennummer.
