# REFUSED ACL

Zu Modul 01: [01-namensaufloesung-und-dns-architektur](../01.1-namensaufloesung-und-dns-architektur.md). Dort steht die ausführliche Anleitung.

## Ziel

Eine Abweisung durch eine Zugriffsliste (`REFUSED`) erkennen.

## Voraussetzungen

- Ein Server, dessen `allow-query` nur bestimmte Netze zulässt (Modul 3).
- Eine Quelladresse, die nicht erlaubt ist (hier `10.77.0.5`). Sie muss auf dem Rechner mit `dig` als Adresse vorhanden sein, sonst kann `-b` sie nicht als Absender benutzen.

## Schritte

1. Sende die Abfrage mit einer anderen Quelladresse (`-b`):

   ```bash
   dig @192.168.50.11 -b 10.77.0.5 branch.example.org SOA +norecurse
   ```

2. Lies den `status:` und achte auf die Zeile `EDE: 18 (Prohibited)`.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
; Mitschnitt aus einer Testumgebung (Ubuntu 24.04, BIND 9.18.39), nicht aus dem Labor der Uebung.
; Befehl: dig @192.168.50.11 -b 10.77.0.5 branch.example.org SOA +norecurse


; <<>> DiG 9.18.39-0ubuntu0.24.04.9-Ubuntu <<>> @192.168.50.11 -b 10.77.0.5 branch.example.org SOA +norecurse
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: REFUSED, id: 28025
;; flags: qr; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 34b1a9aab4cb2be1010000006af4856c7ba550344fdcd99d (good)
; EDE: 18 (Prohibited)
;; QUESTION SECTION:
;branch.example.org.		IN	SOA

;; Query time: 4 msec
;; SERVER: 192.168.50.11#53(192.168.50.11) (UDP)
;; WHEN: Wed Nov 11 16:10:36 CET 2026
;; MSG SIZE  rcvd: 81
```

## So liest du die Ausgabe

- `status: REFUSED`: Der Server hat die Abfrage bewusst abgelehnt. Er ist erreichbar, aber diese Quelle darf nicht fragen.
- `flags: qr` ohne `aa` und ohne `ra`: Es gab keine Antwort aus Daten.
- `EDE: 18 (Prohibited)` (Extended DNS Error) benennt den Grund.
- Merke: `REFUSED` bedeutet Zugriff, `SERVFAIL` bedeutet Fehler beim Auflösen, `NXDOMAIN` bedeutet Name nicht vorhanden.

## Selbst ausprobieren

Frage mit der Quelladresse `192.168.50.100` ab, sie ist erlaubt und liefert die normale Antwort.
