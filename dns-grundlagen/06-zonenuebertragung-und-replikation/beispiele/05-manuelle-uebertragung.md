# Manuelle Übertragung

Zu Modul 06: [06-zonenuebertragung-und-replikation](../06.1-zonenuebertragung-und-replikation.md). Dort steht die ausführliche Anleitung.

## Ziel

Übertragungen von Hand auslösen und den Unterschied zwischen `refresh` und `retransfer` erkennen.

## Voraussetzungen

- SRV-LIN-BIND ist Sekundärserver für `corp.example.com`.
- Im Test war der Primärserver eine BIND-Instanz als Stellvertreter für SRV-WIN-DNS.

## Schritte

1. Frage beim Primärserver nach, ob die Zone neuer ist:

   ```bash
   sudo rndc refresh corp.example.com
   ```

2. Erzwinge eine vollständige Übertragung, auch bei gleicher Seriennummer:

   ```bash
   sudo rndc retransfer corp.example.com
   ```

3. Lies das Log. Entziehe dem Sekundärserver die Berechtigung auf dem Primärserver und wiederhole Schritt 2.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus. Der Windows-Server wurde im Test durch eine zweite BIND-Instanz ersetzt. **Echte Windows-Ausgaben können abweichen.**

```text
# Echte Logzeilen von SRV-LIN-BIND (BIND 9.18.39): manuell ausgeloeste Uebertragungen

$ sudo rndc refresh corp.example.com
zone refresh queued
(Log: nur  received control channel command .refresh corp.example.com.  ; ist die Seriennummer gleich, folgt keine Uebertragung)

$ sudo rndc retransfer corp.example.com   (erzwingt vollstaendige Uebertragung, auch bei gleicher Seriennummer)
11-Nov-2026 16:33:16.805 received control channel command 'retransfer corp.example.com'
11-Nov-2026 16:33:16.809 zone corp.example.com/IN: Transfer started.
11-Nov-2026 16:33:16.809 zone corp.example.com/IN: transferred serial 2026111103
11-Nov-2026 16:33:16.809 transfer of 'corp.example.com/IN' from 192.168.50.10#53: Transfer status: success

## Primaerserver verweigert den Transfer (Absenderadresse nicht in allow-transfer)
11-Nov-2026 16:33:18.865 transfer of 'corp.example.com/IN' from 192.168.50.10#53: failed while receiving responses: REFUSED
11-Nov-2026 16:33:18.865 transfer of 'corp.example.com/IN' from 192.168.50.10#53: Transfer status: REFUSED
```

## So liest du die Ausgabe

- `rndc refresh` meldet nur `zone refresh queued`. Ist die Seriennummer gleich, folgt **keine** Übertragung.
- `rndc retransfer` überträgt immer neu. Das Log zeigt `Transfer started` bis `Transfer status: success`.
- `Transfer status: REFUSED`: Der Primärserver lehnt den Absender ab. Prüfe `allow-transfer` auf dem Primärserver.

## Selbst ausprobieren

Nutze `rndc retransfer` nach jeder Änderung an `allow-transfer`, um den neuen Stand sofort zu testen.
