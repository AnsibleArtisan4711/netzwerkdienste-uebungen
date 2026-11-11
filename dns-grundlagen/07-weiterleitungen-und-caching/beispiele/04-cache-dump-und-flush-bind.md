# BIND: Cache-Dump und Flush

Zu Modul 07: [07-weiterleitungen-und-caching](../07.1-weiterleitungen-und-caching.md). Dort steht die ausführliche Anleitung.

## Ziel

Den Cache von BIND ansehen und leeren.

## Voraussetzungen

- SRV-LIN-BIND leitet `lab.internal` weiter und hat dort bereits einen Namen aufgelöst (`testhost.lab.internal`).

## Schritte

1. Löse den Namen auf, damit er im Cache steht:

   ```bash
   dig @192.168.50.11 testhost.lab.internal A +short
   ```

2. Schreibe den Cache in eine Datei und suche den Eintrag:

   ```bash
   sudo rndc dumpdb -cache
   sudo grep -n -A3 "testhost" /var/cache/bind/named_dump.db
   ```

3. Leere den Cache und zähle die Treffer erneut:

   ```bash
   sudo rndc flush
   sudo rndc dumpdb -cache; sudo grep -c testhost /var/cache/bind/named_dump.db
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
$ dig @192.168.50.11 testhost.lab.internal A +short     # lab.internal wird von SRV-LIN-BIND weitergeleitet
192.168.50.120
$ sudo rndc dumpdb -cache
$ sudo grep -n -A3 "testhost" /var/cache/bind/named_dump.db
9-; authanswer
10:testhost.lab.internal.	3600	IN A	192.168.50.120
11-;
12-; Address database dump

$ sudo rndc flush
$ sudo rndc dumpdb -cache; sudo grep -c testhost /var/cache/bind/named_dump.db
0
```

## So liest du die Ausgabe

- `; authanswer` markiert eine Antwort, die der Server beim Weiterleiten erhalten hat. Sie steht mit TTL `3600` im Cache.
- Nach `rndc flush` zählt `grep -c` **0** Treffer.
- Einen einzelnen Namen entfernt `rndc flushname <name>`. Die Datei `named_dump.db` ist eine Momentaufnahme, sie wird erst durch `rndc dumpdb` neu geschrieben.

## Selbst ausprobieren

Prüfe mit `rndc flushname testhost.lab.internal`, dass nur dieser Eintrag verschwindet.
