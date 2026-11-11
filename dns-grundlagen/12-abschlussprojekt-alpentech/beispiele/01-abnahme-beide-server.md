# Abnahme auf beiden Servern

Zu Modul 12: [12-abschlussprojekt-alpentech](../12.1-abschlussprojekt-alpentech.md). Dort steht die ausführliche Anleitung.

## Ziel

Den Abnahmetest des Abschlussprojekts auf beiden Servern ausführen und das Ergebnis lesen.

## Voraussetzungen

- Die Zonen `hq.alpentech.internal` und `dev.alpentech.internal` und ihre Reverse-Zonen sind auf SRV-WIN-DNS und SRV-LIN-BIND eingerichtet (Modul 12).
- Das Skript `12.1-abnahme-pruefen.sh` liegt im Modulordner, es arbeitet nur lesend. Im Test war der Windows-Server eine BIND-Instanz.

## Schritte

1. Starte die Prüfung von einem Rechner im Labornetz. `SRC` setzt die Absenderadresse für `dig -b`:

   ```bash
   SRC=192.168.50.100 bash 12.1-abnahme-pruefen.sh
   ```

2. Lies die `INFO`-Zeilen (Seriennummern) und die Summe am Ende.
3. Prüfe den Rückgabewert (`echo $?`): `0` heißt alles in Ordnung, `1` mindestens ein Fehler.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus. Der Windows-Server wurde im Test durch eine zweite BIND-Instanz ersetzt. **Echte Windows-Ausgaben können abweichen.**

```text
$ SRC=192.168.50.100 bash 12.1-abnahme-pruefen.sh
== Server 192.168.50.10
INFO    Seriennummer hq.alpentech.internal auf 192.168.50.10: 2026111201
INFO    Seriennummer dev.alpentech.internal auf 192.168.50.10: 2026111201
== Server 192.168.50.11
INFO    Seriennummer hq.alpentech.internal auf 192.168.50.11: 2026111201
INFO    Seriennummer dev.alpentech.internal auf 192.168.50.11: 2026111201

Bestanden: 76   Fehler: 0
Ergebnis: alles in Ordnung
```

## So liest du die Ausgabe

- Pro Server werden Vorwärts- und Rückwärtseinträge, Seriennummern und gesperrter Zonentransfer geprüft: Hier 38 Prüfungen je Server, also `76` insgesamt.
- Gleiche Seriennummern auf beiden Servern: Die Zonen sind synchron.
- Bei einer Abweichung zeigt das Skript `FEHLT` mit erwartetem und erhaltenem Wert.

## Selbst ausprobieren

Ändere in einer Zone einen Wert und führe das Skript erneut aus: Es zeigt den Unterschied.
