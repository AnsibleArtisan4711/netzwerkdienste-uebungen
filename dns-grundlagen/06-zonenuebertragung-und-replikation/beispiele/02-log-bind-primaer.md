# Log des BIND-Primärservers

Zu Modul 06: [06-zonenuebertragung-und-replikation](../06.1-zonenuebertragung-und-replikation.md). Dort steht die ausführliche Anleitung.

## Ziel

Im Log des Primärservers erkennen, ob eine Übertragung stattfindet, und warum sie ausbleibt oder auf AXFR zurückfällt.

## Voraussetzungen

- SRV-LIN-BIND ist Primärserver für `branch.example.org`, die Gegenstelle ist `192.168.50.10`.
- Im Test war die Gegenstelle eine BIND-Instanz als Stellvertreter für SRV-WIN-DNS.

## Schritte

1. Beobachte das Log bei der ersten Übertragung:

   ```bash
   sudo journalctl -u named -n 40 --no-pager
   ```

2. Ändere einen Eintrag, **erhöhe die Seriennummer nicht**, lade die Zone neu und lies das Log erneut.
3. Ändere nun einen Eintrag **mit** erhöhter Seriennummer, bearbeite die Zonendatei von Hand und lade neu.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus. Der Windows-Server wurde im Test durch eine zweite BIND-Instanz ersetzt. **Echte Windows-Ausgaben können abweichen.**

```text
# Echte Logzeilen von SRV-LIN-BIND als Primaerserver fuer branch.example.org (BIND 9.18.39). Gegenstelle war ein BIND als Stellvertreter fuer SRV-WIN-DNS.

## 1. Erste Uebertragung an 192.168.50.10 (AXFR)
11-Nov-2026 16:32:51.693 192.168.50.10#38133 (branch.example.org): transfer of 'branch.example.org/IN': AXFR started (serial 2026111102)
11-Nov-2026 16:32:51.693 192.168.50.10#38133 (branch.example.org): transfer of 'branch.example.org/IN': AXFR ended: 1 messages, 12 records, 413 bytes, 0.001 secs (413000 bytes/sec) (serial 2026111102)

## 2. Seriennummer nicht erhoeht: NOTIFY kommt an, Gegenstelle antwortet 'zone is up to date'
11-Nov-2026 16:33:28.073 zone branch.example.org/IN: notify from 192.168.50.11#36569: zone is up to date

## 3. Seriennummer erhoeht, Zonendatei von Hand bearbeitet und rndc reload: kein Journal, daher AXFR statt IXFR
11-Nov-2026 16:33:38.869 192.168.50.10#32879 (branch.example.org): transfer of 'branch.example.org/IN': IXFR version not in journal, falling back to AXFR
11-Nov-2026 16:33:38.869 192.168.50.10#32879 (branch.example.org): transfer of 'branch.example.org/IN': AXFR-style IXFR started (serial 2026111103)
11-Nov-2026 16:33:38.869 192.168.50.10#32879 (branch.example.org): transfer of 'branch.example.org/IN': AXFR-style IXFR ended: 1 messages, 13 records, 433 bytes, 0.001 secs (433000 bytes/sec) (serial 2026111103)
```

## So liest du die Ausgabe

- `AXFR started … ended`: vollständige Übertragung an die Gegenstelle.
- `zone is up to date`: Die Gegenstelle meldet, dass ihre Seriennummer nicht niedriger ist. **Ohne höhere Seriennummer wird nichts übertragen.**
- `IXFR version not in journal, falling back to AXFR`: Bei Änderungen von Hand fehlt das Journal, daher überträgt der Server die ganze Zone.

## Selbst ausprobieren

Erhöhe die Seriennummer um 1 und beobachte, dass sofort ein NOTIFY und eine Übertragung folgen.
