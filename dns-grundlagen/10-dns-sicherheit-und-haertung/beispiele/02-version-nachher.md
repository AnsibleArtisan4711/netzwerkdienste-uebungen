# Version nachher

Zu Modul 10: [10-dns-sicherheit-und-haertung](../10.1-dns-sicherheit-und-haertung.md). Dort steht die ausführliche Anleitung.

## Ziel

Prüfen, dass die Härtung greift: Version und Servername werden nicht mehr verraten.

## Voraussetzungen

- In den `options` stehen `version "unavailable";`, `hostname none;` und `server-id none;` (`10.1-named.conf.options-haertung`).

## Schritte

1. Prüfe die Konfiguration und lade neu:

   ```bash
   sudo named-checkconf
   sudo rndc reload
   ```

2. Frage alle drei Werte ab:

   ```bash
   dig @192.168.50.11 version.bind CHAOS TXT +short
   dig @192.168.50.11 hostname.bind CHAOS TXT +short
   dig @192.168.50.11 id.server CHAOS TXT +short
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
$ dig @192.168.50.11 version.bind CHAOS TXT +short
"unavailable"
$ dig @192.168.50.11 hostname.bind CHAOS TXT +short
$ dig @192.168.50.11 id.server CHAOS TXT +short
```

## So liest du die Ausgabe

- `version.bind` liefert `"unavailable"` statt der echten Version.
- `hostname.bind` und `id.server` bleiben leer, es gibt keine Antwort.
- Das ist nur eine **Zusatzmaßnahme**: Die eigentliche Sicherheit kommt aus Updates und Zugriffsbeschränkungen, nicht aus Verschleierung.

## Selbst ausprobieren

Setze die Zeile `version` wieder zurück und vergleiche mit dem vorigen Beispiel.
