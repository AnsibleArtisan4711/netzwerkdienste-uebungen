# allow-transfer: none

Zu Modul 10: [10-dns-sicherheit-und-haertung](../10.1-dns-sicherheit-und-haertung.md). Dort steht die ausführliche Anleitung.

## Ziel

Eine globale Sperre `allow-transfer { none; };` einrichten und prüfen, dass nur die Zone mit eigener Freigabe noch übertragbar ist.

## Voraussetzungen

- In `options` steht `allow-transfer { none; };`. Die Zone `branch.example.org` hat zusätzlich `allow-transfer { 192.168.50.10; };`.
- `192.168.50.10` ist der Windows-Secondary. Im Test war es eine BIND-Instanz als Stellvertreter.

## Schritte

1. Trage die globale Zeile ein, prüfe und lade neu:

   ```bash
   sudo named-checkconf
   sudo rndc reload
   ```

2. Versuche Zonenabzüge von einem Fremdrechner:

   ```bash
   dig -b 192.168.50.100 @192.168.50.11 partner.example.net AXFR
   dig -b 192.168.50.100 @192.168.50.11 branch.example.org AXFR
   ```

3. Versuche den Abzug vom Partner:

   ```bash
   dig -b 192.168.50.10 @192.168.50.11 branch.example.org AXFR
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus. Der Windows-Server wurde im Test durch eine zweite BIND-Instanz ersetzt. **Echte Windows-Ausgaben können abweichen.**

```text
# Zonentransfer mit "allow-transfer { none; };" global in options; Zone branch.example.org hat eigenes allow-transfer { 192.168.50.10; }
# vorher (ohne globale Zeile): partner.example.net AXFR aus 192.168.50.100 lieferte "XFR size: 5 records" (Standard ist: alle duerfen)
$ dig -b 192.168.50.100 @192.168.50.11 partner.example.net AXFR
; Transfer failed.
$ dig -b 192.168.50.100 @192.168.50.11 branch.example.org AXFR
; Transfer failed.
$ dig -b 192.168.50.10 @192.168.50.11 branch.example.org AXFR   (Quelle = Windows-Secondary)
;; XFR size: 14 records (messages 1, bytes 494)

# Log:
```

## So liest du die Ausgabe

- Beide Abzüge vom Fremdrechner scheitern (`; Transfer failed.`), auch `partner.example.net`, das vorher auslieferte.
- Der Partner `192.168.50.10` darf `branch.example.org` weiterhin abholen (`XFR size: 14 records`). Die Zonenfreigabe hat Vorrang vor der globalen.
- Die Prüfung gehört in jede Abnahme: **Standard ist offen**, erst die Konfiguration sperrt.

## Selbst ausprobieren

Sperre auch das, was der Partner nicht braucht: Prüfe, dass `partner.example.net` für `192.168.50.10` gesperrt bleibt.
