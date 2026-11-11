# Querylog

Zu Modul 11: [11-fehlersuche-und-monitoring](../11.1-fehlersuche-und-monitoring.md). Dort steht die ausführliche Anleitung.

## Ziel

Das Abfragelog von BIND ein- und ausschalten und lesen: wer hat was gefragt.

## Voraussetzungen

- `named.conf.logging` mit einem Kanal für `queries.log` ist eingebunden (`11.1-named.conf.logging`).

## Schritte

1. Schalte das Abfragelog ein, sende ein paar Abfragen, dann schalte es aus:

   ```bash
   sudo rndc querylog on
   dig @192.168.50.11 www.branch.example.org A +short
   dig @192.168.50.11 linserver.branch.example.org A +short
   dig @192.168.50.11 nichtda.branch.example.org A +short
   dig @192.168.50.11 testhost.lab.internal AAAA +short
   sudo rndc querylog off
   ```

2. Lies die Datei:

   ```bash
   sudo cat /var/log/named/queries.log
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
$ sudo rndc querylog on
$ (vier Abfragen)
$ sudo rndc querylog off
$ (eine weitere Abfrage; steht nicht im Log)
$ sudo cat /var/log/named/queries.log
11-Nov-2026 17:17:37.982 queries: client 192.168.50.11#36276 (www.branch.example.org): query: www.branch.example.org IN A +E(0)K (192.168.50.11)
11-Nov-2026 17:17:38.010 queries: client 192.168.50.11#53964 (linserver.branch.example.org): query: linserver.branch.example.org IN A +E(0)K (192.168.50.11)
11-Nov-2026 17:17:38.034 queries: client 192.168.50.11#41212 (nichtda.branch.example.org): query: nichtda.branch.example.org IN A +E(0)K (192.168.50.11)
11-Nov-2026 17:17:38.054 queries: client 192.168.50.100#35669 (testhost.lab.internal): query: testhost.lab.internal IN AAAA +E(0)K (192.168.50.11)
```

## So liest du die Ausgabe

- Jede Zeile nennt Absenderadresse und Port, den Namen, die Klasse (`IN`), den Typ und Flags: `+` = Rekursion gewünscht, `E(0)` = EDNS Version 0, `K` = Cookie vorhanden.
- Am Ende in Klammern steht die Zieladresse des Servers.
- Abfragen **nach** `querylog off` stehen nicht mehr im Log.
- Das Querylog wächst schnell. Schalte es nur zur Fehlersuche ein und achte auf Datenschutz.

## Selbst ausprobieren

Filtere die Zeilen eines Clients mit `grep 192.168.50.100`.
