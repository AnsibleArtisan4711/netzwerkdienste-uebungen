# Verhalten nach Expire

Zu Modul 12: [12-abschlussprojekt-alpentech](../12.1-abschlussprojekt-alpentech.md). Dort steht die ausführliche Anleitung.

## Ziel

Beobachten, wie ein Sekundärserver reagiert, wenn der Primärserver nicht mehr erreichbar ist: Nach Ablauf von `expire` antwortet er nicht mehr.

## Voraussetzungen

- Eine Testzone `expiretest.alpentech.internal` mit SOA `1 20 10 40 5` (Refresh 20 s, Retry 10 s, Expire 40 s).
- BIND setzt **zu kurze** SOA-Zeiten auf Mindestwerte hoch. Für den Test steht in der Sekundärzone `min-refresh-time 5; min-retry-time 5;`.
- Nur für den Test! In der Praxis sind Expire-Zeiten in der Größenordnung von Tagen üblich (hier im Projekt 604800 s).

## Schritte

1. Frage die Testzone am Sekundärserver ab und lies den Ablauf:

   ```bash
   dig @192.168.50.11 test.expiretest.alpentech.internal A +short
   rndc zonestatus expiretest.alpentech.internal | grep -E "last loaded|expires"
   ```

2. Beende den Primärserver (im Test `rndcb stop`, unter Windows `Stop-Service DNS`).
3. Frage in Abständen von etwa 10 bis 15 Sekunden erneut und lies den Status:

   ```bash
   dig @192.168.50.11 test.expiretest.alpentech.internal A | grep status
   ```

4. Lies das Log des Sekundärservers.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# Expire-Test mit Testzone expiretest.alpentech.internal: SOA 1 20 10 40 5 (Refresh 20 s, Retry 10 s, Expire 40 s)
# BIND setzt zu kurze SOA-Zeiten auf Mindestwerte hoch (Standard); fuer den Test wurde in der Sekundaerzone min-refresh-time 5; min-retry-time 5; gesetzt.
$ dig @192.168.50.11 test.expiretest.alpentech.internal A +short   (Sekundaer, Primaer erreichbar)
192.168.50.99
$ rndc zonestatus expiretest.alpentech.internal | grep -E "last loaded|expires"
last loaded: Wed, 11 Nov 2026 16:26:50 GMT
expires: Wed, 11 Nov 2026 16:27:30 GMT
$ rndcb stop    (Primaer faellt aus)
+ 10s  status: NOERROR
+ 25s  status: NOERROR
+ 45s  status: SERVFAIL
+ 60s  status: SERVFAIL
# Log des Sekundaers (Auszug):
11-Nov-2026 17:27:30.950 general: zone expiretest.alpentech.internal/IN: expired
11-Nov-2026 17:27:30.950 general: zone expiretest.alpentech.internal/IN: refresh: failure trying primary 192.168.50.10#53 (source 0.0.0.0#0): connection refused
11-Nov-2026 17:27:48.634 query-errors: client 192.168.50.11#34647 (test.expiretest.alpentech.internal): query failed (zone not loaded) for test.expiretest.alpentech.internal/IN/A at query.c:5711
11-Nov-2026 17:28:03.670 query-errors: client 192.168.50.11#35702 (test.expiretest.alpentech.internal): query failed (zone not loaded) for test.expiretest.alpentech.internal/IN/A at query.c:5711
$ rndc zonestatus expiretest.alpentech.internal | grep -E "expires|serial"
```

## So liest du die Ausgabe

- Bis zum Ablauf (`expires`) antwortet der Sekundär weiter mit `NOERROR`, obwohl der Primär fehlt.
- Nach 45 Sekunden: `SERVFAIL`. Im Log steht `expired` und `zone not loaded`.
- Das Ziel: Eine tote Zone soll nicht ewig veraltete Daten ausliefern. Deshalb gehört `expire` weit über die längste geplante Ausfallzeit.
- Die Zeitangaben in `zonestatus` stehen in GMT, das Log in Ortszeit (Unterschied eine Stunde).

## Selbst ausprobieren

Starte den Primärserver wieder: Die Zone wird beim nächsten Refresh neu geladen.
