# Version vorher

Zu Modul 10: [10-dns-sicherheit-und-haertung](../10.1-dns-sicherheit-und-haertung.md). Dort steht die ausführliche Anleitung.

## Ziel

Zeigen, dass ein Server standardmäßig seine genaue Softwareversion verrät.

## Voraussetzungen

- SRV-LIN-BIND mit der Konfiguration aus Modul 3, noch **ohne** `version`-Zeile.

## Schritte

1. Frage die Version über die CHAOS-Klasse ab:

   ```bash
   dig @192.168.50.11 version.bind CHAOS TXT +short
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
$ dig @192.168.50.11 version.bind CHAOS TXT +short
"9.18.39-0ubuntu0.24.04.9-Ubuntu"
```

## So liest du die Ausgabe

- Die Antwort nennt die genaue BIND-Version samt Distributionsstand. Wer sie kennt, kann gezielt nach bekannten Schwachstellen dieser Version suchen.
- Das ist ein **Informationsleck**, kein Einbruch. Es erleichtert aber Angreifern die Arbeit.

## Selbst ausprobieren

Frage zusätzlich `hostname.bind` und `id.server` ab, sie liefern Servernamen und Kennung.
