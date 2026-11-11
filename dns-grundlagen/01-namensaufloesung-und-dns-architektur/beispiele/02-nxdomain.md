# NXDOMAIN

Zu Modul 01: [01-namensaufloesung-und-dns-architektur](../01.1-namensaufloesung-und-dns-architektur.md). Dort steht die ausführliche Anleitung.

## Ziel

Erkennen, wie ein nicht vorhandener Name aussieht (`NXDOMAIN`), und wo die Zone die Verneinung begründet.

## Voraussetzungen

- Derselbe Server und dieselbe Zone wie im vorigen Beispiel.
- Ein Name, den es in der Zone nicht gibt (hier `gibtsnicht`).

## Schritte

1. Frage einen Namen ab, den es nicht gibt:

   ```bash
   dig @192.168.50.11 gibtsnicht.branch.example.org A +norecurse
   ```

2. Lies den `status:` im Kopf.
3. Prüfe, dass `ANSWER` leer ist und stattdessen `AUTHORITY` einen SOA-Eintrag enthält.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
; Mitschnitt aus einer Testumgebung (Ubuntu 24.04, BIND 9.18.39), nicht aus dem Labor der Uebung.
; Befehl: dig @192.168.50.11 gibtsnicht.branch.example.org A +norecurse


; <<>> DiG 9.18.39-0ubuntu0.24.04.9-Ubuntu <<>> @192.168.50.11 gibtsnicht.branch.example.org A +norecurse
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 57420
;; flags: qr aa ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 7440c63e624d63be010000006af4856cdb086f9304c1ed27 (good)
;; QUESTION SECTION:
;gibtsnicht.branch.example.org.	IN	A

;; AUTHORITY SECTION:
branch.example.org.	3600	IN	SOA	linserver.branch.example.org. hostmaster.branch.example.org. 2026110801 900 300 604800 3600

;; Query time: 0 msec
;; SERVER: 192.168.50.11#53(192.168.50.11) (UDP)
;; WHEN: Wed Nov 11 16:10:36 CET 2026
;; MSG SIZE  rcvd: 143
```

## So liest du die Ausgabe

- `status: NXDOMAIN`: Der Name existiert nicht, und zwar für **keinen** Typ.
- `ANSWER: 0`: Es gibt keine Daten. Die Zahl hinter `AUTHORITY: 1` zeigt den mitgelieferten SOA-Eintrag.
- `aa` ist gesetzt: Der zuständige Server verneint verbindlich, es ist keine Vermutung eines Caches.
- Der SOA-Eintrag in der Autorität ist die Grundlage für das **negative Caching** (Modul 7): Wie lange sich andere Server die Verneinung merken, hängt von seinen Zeitwerten ab.

## Selbst ausprobieren

Frage einen Namen mit Tippfehler ab und prüfe, ob du wirklich `NXDOMAIN` erhältst.
