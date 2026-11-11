# Negatives Caching

Zu Modul 07: [07-weiterleitungen-und-caching](../07.1-weiterleitungen-und-caching.md). Dort steht die ausführliche Anleitung.

## Ziel

Sehen, wie lange ein Server die Verneinung (`NXDOMAIN`) im Cache behält.

## Voraussetzungen

- Weiterleitende Konfiguration wie im vorigen Beispiel.
- Die Zone `partner.example.net` hat Zonen-TTL 3600 und SOA-Minimum 300, also gilt 300 Sekunden.

## Schritte

1. Frage einen nicht vorhandenen Namen über den weiterleitenden Server ab:

   ```bash
   dig @192.168.50.10 gibtsnicht.partner.example.net A
   ```

2. Wiederhole die Abfrage nach einigen Sekunden und achte auf die TTL des SOA-Eintrags.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus. Der Windows-Server wurde im Test durch eine zweite BIND-Instanz ersetzt. **Echte Windows-Ausgaben können abweichen.**

```text
# Negatives Caching: NXDOMAIN wird so lange gemerkt wie der kleinere Wert aus SOA-TTL und SOA-Minimum
# (Zone partner.example.net: Zonen-TTL 3600, SOA-Minimum 300 -> 300 Sekunden)
$ dig @192.168.50.10 gibtsnicht.partner.example.net A
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: .
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 0
;; AUTHORITY SECTION:
partner.example.net.	300	IN	SOA	linserver.branch.example.org. hostmaster.branch.example.org. 2026111201 900 300 604800 300

# 7 Sekunden spaeter (gleiche Abfrage)
partner.example.net.	293	IN	SOA	linserver.branch.example.org. hostmaster.branch.example.org. 2026111201 900 300 604800 300
```

## So liest du die Ausgabe

- Die Verneinung steht mit der TTL `300` im Cache. Sieben Sekunden später steht dort `293`.
- Die Zeit richtet sich nach dem **kleineren** Wert aus SOA-TTL und SOA-Minimum.
- Folge: Ein neu angelegter Name wird erst nach Ablauf der negativen TTL sichtbar, wenn jemand vorher nachgefragt hat.

## Selbst ausprobieren

Lege den Namen an der Quelle an und frage erneut. Beobachte, wann er sichtbar wird.
