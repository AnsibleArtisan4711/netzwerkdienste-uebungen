# Abfrage per TCP

Zu Modul 01: [01-namensaufloesung-und-dns-architektur](../01.1-namensaufloesung-und-dns-architektur.md). Dort steht die ausführliche Anleitung.

## Ziel

Dieselbe große Antwort über TCP vollständig erhalten und zeigen, warum TCP 53 offen sein muss.

## Voraussetzungen

- Dieselbe Testzone wie im vorigen Beispiel.

## Schritte

1. Wiederhole die Abfrage per TCP:

   ```bash
   dig @192.168.50.11 viel.big.example.org TXT +tcp +norecurse
   ```

2. Zähle die Einträge in `ANSWER` und lies die Zeile `SERVER: … (TCP)` am Ende.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
; Mitschnitt aus einer Testumgebung (Ubuntu 24.04, BIND 9.18.39), nicht aus dem Labor der Uebung.
; Befehl: dig @192.168.50.11 viel.big.example.org TXT +tcp +norecurse


; <<>> DiG 9.18.39-0ubuntu0.24.04.9-Ubuntu <<>> @192.168.50.11 viel.big.example.org TXT +tcp +norecurse
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 24426
;; flags: qr aa ra; QUERY: 1, ANSWER: 12, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 6d47cc529d155483010000006af4856c4bd0be7ee146ada7 (good)
;; QUESTION SECTION:
;viel.big.example.org.		IN	TXT

;; ANSWER SECTION:
viel.big.example.org.	3600	IN	TXT	"eintrag-10-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
viel.big.example.org.	3600	IN	TXT	"eintrag-6-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
viel.big.example.org.	3600	IN	TXT	"eintrag-2-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
viel.big.example.org.	3600	IN	TXT	"eintrag-7-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
viel.big.example.org.	3600	IN	TXT	"eintrag-1-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
viel.big.example.org.	3600	IN	TXT	"eintrag-5-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
viel.big.example.org.	3600	IN	TXT	"eintrag-3-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
viel.big.example.org.	3600	IN	TXT	"eintrag-11-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
viel.big.example.org.	3600	IN	TXT	"eintrag-4-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
viel.big.example.org.	3600	IN	TXT	"eintrag-9-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
viel.big.example.org.	3600	IN	TXT	"eintrag-12-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
viel.big.example.org.	3600	IN	TXT	"eintrag-8-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

;; AUTHORITY SECTION:
big.example.org.	3600	IN	NS	ns.big.example.org.

;; ADDITIONAL SECTION:
ns.big.example.org.	3600	IN	A	192.168.50.11

;; Query time: 4 msec
;; SERVER: 192.168.50.11#53(192.168.50.11) (TCP)
;; WHEN: Wed Nov 11 16:10:36 CET 2026
;; MSG SIZE  rcvd: 1109
```

## So liest du die Ausgabe

- Jetzt stehen alle 12 Einträge in der Antwort, die Größe liegt bei 1109 Byte.
- `(TCP)` in der `SERVER`-Zeile bestätigt den Weg.
- Folge für den Betrieb: Wird TCP 53 auf einer Firewall blockiert, scheitern große Antworten und Zonentransfers, kleine Abfragen funktionieren weiter. Das siehst du später in Modul 11 (Szenario A).

## Selbst ausprobieren

Setze die Abfrage ohne `+tcp` und mit EDNS ab: Passt sie in 1232 Byte, kommt sie über UDP.
