# NODATA

Zu Modul 01: [01-namensaufloesung-und-dns-architektur](../01.1-namensaufloesung-und-dns-architektur.md). Dort steht die ausführliche Anleitung.

## Ziel

`NODATA` von `NXDOMAIN` unterscheiden: Der Name existiert, aber nicht für den gefragten Typ.

## Voraussetzungen

- Ein Name, den es in der Zone gibt (hier `linserver`), für den aber **kein** `AAAA`-Eintrag angelegt ist.
- In der Zone zum Zeitpunkt des Mitschnitts gab es keinen AAAA-Eintrag. In Modul 5 kommt einer hinzu, die Ausgabe sähe dann anders aus.

## Schritte

1. Frage den Typ `AAAA` ab:

   ```bash
   dig @192.168.50.11 linserver.branch.example.org AAAA +norecurse
   ```

2. Vergleiche den `status:` mit dem Beispiel `NXDOMAIN`.
3. Prüfe `ANSWER: 0` und den SOA-Eintrag in der Autorität.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
; Mitschnitt aus einer Testumgebung (Ubuntu 24.04, BIND 9.18.39), nicht aus dem Labor der Uebung.
; Befehl: dig @192.168.50.11 linserver.branch.example.org AAAA +norecurse


; <<>> DiG 9.18.39-0ubuntu0.24.04.9-Ubuntu <<>> @192.168.50.11 linserver.branch.example.org AAAA +norecurse
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 16470
;; flags: qr aa ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 8797e50e005e8e57010000006af4856cc70db5062a7e3d81 (good)
;; QUESTION SECTION:
;linserver.branch.example.org.	IN	AAAA

;; AUTHORITY SECTION:
branch.example.org.	3600	IN	SOA	linserver.branch.example.org. hostmaster.branch.example.org. 2026110801 900 300 604800 3600

;; Query time: 0 msec
;; SERVER: 192.168.50.11#53(192.168.50.11) (UDP)
;; WHEN: Wed Nov 11 16:10:36 CET 2026
;; MSG SIZE  rcvd: 132
```

## So liest du die Ausgabe

- `status: NOERROR` trotz leerer Antwort: Der Name ist vorhanden, nur dieser Typ nicht. Das ist **NODATA**.
- Bei `NXDOMAIN` gibt es den Namen gar nicht. Wer das verwechselt, sucht beim Fehlerbild an der falschen Stelle.
- Auch hier steht der SOA-Eintrag in der Autorität (für das negative Caching).

## Selbst ausprobieren

Frage denselben Namen mit Typ `A` ab: Jetzt kommt eine Antwort mit Adresse.
