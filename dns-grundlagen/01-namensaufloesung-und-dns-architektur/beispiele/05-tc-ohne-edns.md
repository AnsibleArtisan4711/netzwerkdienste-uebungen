# TC ohne EDNS

Zu Modul 01: [01-namensaufloesung-und-dns-architektur](../01.1-namensaufloesung-und-dns-architektur.md). Dort steht die ausführliche Anleitung.

## Ziel

Sehen, was passiert, wenn eine Antwort nicht in ein altes UDP-Paket (512 Byte) passt: Das Flag `tc` (truncated).

## Voraussetzungen

- Eine Testzone `big.example.org` mit vielen langen TXT-Einträgen unter `viel.big.example.org`.
- Die Zone gehört **nicht** zum Labor, sie dient nur diesem Beispiel.

## Schritte

1. Frage per UDP **ohne** EDNS ab und verhindere den automatischen Wechsel auf TCP:

   ```bash
   dig @192.168.50.11 viel.big.example.org TXT +noedns +ignore +norecurse
   ```

2. Suche in den `flags:` nach `tc`.
3. Zähle die Einträge: `ANSWER: 5` ist nur ein Teil der Antwort.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
; Mitschnitt aus einer Testumgebung (Ubuntu 24.04, BIND 9.18.39), nicht aus dem Labor der Uebung.
; Befehl: dig @192.168.50.11 viel.big.example.org TXT +noedns +ignore +norecurse


; <<>> DiG 9.18.39-0ubuntu0.24.04.9-Ubuntu <<>> @192.168.50.11 viel.big.example.org TXT +noedns +ignore +norecurse
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 55646
;; flags: qr aa tc ra ad; QUERY: 1, ANSWER: 5, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;viel.big.example.org.		IN	TXT

;; ANSWER SECTION:
viel.big.example.org.	3600	IN	TXT	"eintrag-1-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
viel.big.example.org.	3600	IN	TXT	"eintrag-3-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
viel.big.example.org.	3600	IN	TXT	"eintrag-9-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
viel.big.example.org.	3600	IN	TXT	"eintrag-4-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
viel.big.example.org.	3600	IN	TXT	"eintrag-2-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

;; Query time: 0 msec
;; SERVER: 192.168.50.11#53(192.168.50.11) (UDP)
;; WHEN: Wed Nov 11 16:10:36 CET 2026
;; MSG SIZE  rcvd: 453
```

## So liest du die Ausgabe

- `tc` heißt: Die Antwort wurde abgeschnitten, weil sie nicht in die UDP-Grenze passt (ohne EDNS 512 Byte).
- `+noedns` schaltet die größere Paketgröße aus. `+ignore` verhindert, dass `dig` bei `tc` selbst auf TCP wechselt. Normalerweise passiert das automatisch.
- Im nächsten Beispiel (`06-per-tcp`) kommt dieselbe Frage per TCP mit der vollständigen Antwort.

## Selbst ausprobieren

Lasse `+noedns` weg und vergleiche `MSG SIZE` und das `tc`-Flag.
