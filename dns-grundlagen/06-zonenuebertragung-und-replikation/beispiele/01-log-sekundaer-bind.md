# Log des BIND-Sekundärservers

Zu Modul 06: [06-zonenuebertragung-und-replikation](../06.1-zonenuebertragung-und-replikation.md). Dort steht die ausführliche Anleitung.

## Ziel

Im Log eines Sekundärservers den Ablauf einer Zonenübertragung erkennen: AXFR, NOTIFY und IXFR.

## Voraussetzungen

- SRV-LIN-BIND ist Sekundärserver für `corp.example.com`, der Primärserver ist `192.168.50.10`.
- Im Test war der Primärserver eine BIND-Instanz als Stellvertreter für SRV-WIN-DNS. Bei echtem Windows kann das Log des Primärservers anders aussehen.

## Schritte

1. Lies auf SRV-LIN-BIND die letzten Logzeilen des Dienstes:

   ```bash
   sudo journalctl -u named -n 40 --no-pager
   ```

2. Löse eine erste Übertragung aus, zum Beispiel nach dem Anlegen der Sekundärzone:

   ```bash
   sudo rndc reconfig
   ```

3. Erhöhe auf dem Primärserver die Seriennummer. Die Zeilen mit `received notify` und die Übertragung erscheinen im Log.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus. Der Windows-Server wurde im Test durch eine zweite BIND-Instanz ersetzt. **Echte Windows-Ausgaben können abweichen.**

```text
# Echte Logzeilen von SRV-LIN-BIND (BIND 9.18.39, Sekundaerserver fuer corp.example.com; Primaerserver war ein BIND als Stellvertreter fuer SRV-WIN-DNS).
# In der Uebung lesen Sie diese Zeilen mit:  sudo journalctl -u named -n 40 --no-pager   (Vorspann von journald weicht ab)

## 1. Erste Uebertragung nach rndc reconfig (AXFR)
11-Nov-2026 16:32:24.065 zone corp.example.com/IN: Transfer started.
11-Nov-2026 16:32:24.065 zone corp.example.com/IN: transferred serial 2026111102
11-Nov-2026 16:32:24.065 transfer of 'corp.example.com/IN' from 192.168.50.10#53: Transfer status: success
11-Nov-2026 16:32:24.065 transfer of 'corp.example.com/IN' from 192.168.50.10#53: Transfer completed: 1 messages, 14 records, 447 bytes, 0.001 secs (447000 bytes/sec) (serial 2026111102)

## 2. NOTIFY des Primaerservers nach Aenderung (Seriennummer erhoeht), danach Uebertragung
11-Nov-2026 16:32:33.785 client @0x7f588d3a5ac8 192.168.50.10#39024: received notify for zone 'corp.example.com'
11-Nov-2026 16:32:33.785 zone corp.example.com/IN: notify from 192.168.50.10#39024: serial 2026111103

## 3. Die Primaer-Seite derselben Uebertragung (IXFR, inkrementell)
11-Nov-2026 16:32:33.785 192.168.50.11#35907 (corp.example.com): transfer of 'corp.example.com/IN': IXFR started (serial 2026111102 -> 2026111103)
11-Nov-2026 16:32:33.785 192.168.50.11#35907 (corp.example.com): transfer of 'corp.example.com/IN': IXFR ended: 1 messages, 5 records, 227 bytes, 0.001 secs (227000 bytes/sec) (serial 2026111103)
```

## So liest du die Ausgabe

- `Transfer started` / `transferred serial …` / `Transfer status: success`: Die erste Übertragung hat die ganze Zone geholt (AXFR, hier 14 Einträge).
- `received notify for zone`: Der Primärserver meldet eine Änderung. Er schickt sie, wenn die Seriennummer steigt.
- `IXFR started (serial … -> …)`: Danach wird nur der Unterschied übertragen (inkrementell), nicht die ganze Zone.
- Der Vorspann der Zeilen (Datum, Dienstname) unterscheidet sich bei `journalctl`.

## Selbst ausprobieren

Zähle in deinem Log die übertragenen Einträge der AXFR und der IXFR und vergleiche.
