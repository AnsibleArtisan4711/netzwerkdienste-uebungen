# AXFR abgelehnt und offen

Zu Modul 06: [06-zonenuebertragung-und-replikation](../06.1-zonenuebertragung-und-replikation.md). Dort steht die ausführliche Anleitung.

## Ziel

Prüfen, wer eine Zone herunterladen darf, und den Unterschied zwischen `allow-transfer` und dem Standard erkennen.

## Voraussetzungen

- Auf SRV-LIN-BIND gilt für `branch.example.org` `allow-transfer` nur für `192.168.50.10`.
- Ein dritter Rechner (hier `192.168.50.100`) als Absender.

## Schritte

1. Versuche einen Zonenabzug von einer nicht freigegebenen Adresse (`-b` setzt die Absenderadresse):

   ```bash
   dig -b 192.168.50.100 @192.168.50.11 branch.example.org AXFR
   ```

2. Suche im Log nach `zone transfer … denied`.
3. Entferne zum Vergleich `allow-transfer` aus der Zone und wiederhole die Abfrage.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# Echte Ausgaben: Zonenabzug durch einen nicht freigegebenen Absender (192.168.50.100). BIND 9.18.39.

$ dig @192.168.50.11 branch.example.org AXFR     (Absender 192.168.50.100, allow-transfer nur fuer 192.168.50.10)
; <<>> DiG 9.18.39-0ubuntu0.24.04.9-Ubuntu <<>> -b 192.168.50.100 @192.168.50.11 branch.example.org AXFR
; Transfer failed.

## Logzeile auf dem angefragten Server
11-Nov-2026 16:35:57.105 192.168.50.100#35917 (branch.example.org): zone transfer 'branch.example.org/AXFR/IN' denied

## Zum Vergleich: ohne allow-transfer (BIND-Standard) liefert derselbe Abzug die ganze Zone (11 Eintraege)
11-Nov-2026 16:32:23.985 192.168.50.100#46675 (branch.example.org): transfer of 'branch.example.org/IN': AXFR started (serial 2026111101)
11-Nov-2026 16:32:23.985 192.168.50.100#46675 (branch.example.org): transfer of 'branch.example.org/IN': AXFR ended: 1 messages, 11 records, 412 bytes, 0.001 secs (412000 bytes/sec) (serial 2026111101)
```

## So liest du die Ausgabe

- `; Transfer failed.` bei `dig` und `denied` im Log: Der Server hat den Abzug verweigert.
- Ohne `allow-transfer` gilt in BIND der **Standard: jeder darf**. Der Server lieferte dann alle 11 Einträge.
- Zonendaten lassen sich so komplett auslesen. Deshalb gehört `allow-transfer` in jede Konfiguration (Modul 10).

## Selbst ausprobieren

Prüfe dasselbe mit der Absenderadresse des Partnerservers `192.168.50.10`: Sie darf übertragen.
