# SERVFAIL extern

Zu Modul 01: [01-namensaufloesung-und-dns-architektur](../01.1-namensaufloesung-und-dns-architektur.md). Dort steht die ausführliche Anleitung.

## Ziel

`SERVFAIL` erkennen und verstehen, dass es ein Fehler des Servers bei der Auflösung ist, keine Aussage über den Namen.

## Voraussetzungen

- Ein Server, der rekursiv auflösen soll (hier `192.168.50.11`).
- Im Testlauf hatte die Umgebung keine Netzverbindung. Im Labor ohne Gateway ist das Verhalten ähnlich, bei einem ins Leere zeigenden Gateway kann es länger dauern.

## Schritte

1. Frage einen externen Namen **mit** Rekursion ab (kein `+norecurse`):

   ```bash
   dig @192.168.50.11 example.net A
   ```

2. Lies `status:` und `flags:`.
3. Vergleiche die Antwortzeit: Hier kam sie nach 8 ms, mit einem toten Gateway wären es Sekunden.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
; Mitschnitt aus einer Testumgebung (Ubuntu 24.04, BIND 9.18.39), nicht aus dem Labor der Uebung.
; Befehl: dig @192.168.50.11 example.net A
; Hinweis: Die Testumgebung hatte keinerlei Netzverbindung; im Labor ohne Gateway ist das Verhalten aehnlich, mit ins Leere zeigendem Gateway kann es laenger dauern.


; <<>> DiG 9.18.39-0ubuntu0.24.04.9-Ubuntu <<>> @192.168.50.11 example.net A
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: SERVFAIL, id: 5587
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: df2bcc1f68c3dc79010000006af4858dab91105b8fd9093d (good)
;; QUESTION SECTION:
;example.net.			IN	A

;; Query time: 8 msec
;; SERVER: 192.168.50.11#53(192.168.50.11) (UDP)
;; WHEN: Wed Nov 11 16:11:09 CET 2026
;; MSG SIZE  rcvd: 68
```

## So liest du die Ausgabe

- `status: SERVFAIL`: Der Server konnte die Frage nicht beantworten. Das ist **kein** `NXDOMAIN`.
- `flags: qr rd ra` ohne `aa`: Die Antwort ist nicht autoritativ. `rd` zeigt, dass Rekursion gewünscht war.
- Prüfe als Erstes den Weg nach außen: Gateway, Forwarder, Root-Hinweise (Modul 7), und das Log des Servers (Modul 11).

## Selbst ausprobieren

Frage einen Namen aus der eigenen Zone ab: Dort bekommst du trotz fehlender Verbindung eine Antwort.
