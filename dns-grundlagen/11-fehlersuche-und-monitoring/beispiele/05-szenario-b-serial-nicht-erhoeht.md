# Szenario B: Serial nicht erhöht

Zu Modul 11: [11-fehlersuche-und-monitoring](../11.1-fehlersuche-und-monitoring.md). Dort steht die ausführliche Anleitung.

## Ziel

Das Szenario „Eintrag geändert, Seriennummer nicht erhöht“ nachstellen: Primär und Sekundär geben verschiedene Antworten.

## Voraussetzungen

- SRV-LIN-BIND ist Primär für `branch.example.org`, `192.168.50.10` Sekundär (im Test eine BIND-Instanz als Stellvertreter für Windows).
- Die Zone ist dynamisch, deshalb gilt: `freeze`, bearbeiten, `thaw` (Modul 8).

## Schritte

1. Messe das Symptom auf beiden Servern: die Adresse von `web` und die Seriennummer der Zone (das Skript vergleicht die Seriennummern):

   ```bash
   dig +short @192.168.50.11 web.branch.example.org A
   dig +short @192.168.50.10 web.branch.example.org A
   bash 11.1-serial-vergleichen.sh branch.example.org 192.168.50.11 192.168.50.10
   ```

2. Ändere `web` in der Zonendatei **ohne** die Seriennummer zu erhöhen:

   ```bash
   sudo rndc freeze branch.example.org
   sudo nano /var/lib/bind/db.branch.example.org
   sudo rndc thaw branch.example.org
   ```

3. Lies das Log des Sekundärservers.
4. Behebe es: Seriennummer erhöhen, wieder zwischen `freeze` und `thaw`. Kontrolle mit denselben `dig`-Abfragen.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus. Der Windows-Server wurde im Test durch eine zweite BIND-Instanz ersetzt. **Echte Windows-Ausgaben können abweichen.**

```text
# Szenario B: A-Record geaendert, Seriennummer nicht erhoeht
$ dig +short @192.168.50.11 web.branch.example.org A   -> 192.168.50.40
Seriennummer SRV-LIN-BIND (Primaer): 2026111112   Windows-Ersatz (Sekundaer): 2026111112
$ sudo rndc freeze branch.example.org
22:web			A	192.168.50.41
$ sudo rndc thaw branch.example.org
A zone reload and thaw was started.
Check the logs to see the result.
$ sudo rndc reload branch.example.org
rndc: 'reload' failed: dynamic zone
Primaer web = 192.168.50.41   Seriennummer Primaer 2026111112
Sekundaer web = 192.168.50.40   Seriennummer Sekundaer 2026111112
# Log Sekundaer (Auszug):
11-Nov-2026 17:17:28.618 zone branch.example.org/IN: notify from 192.168.50.11#37375: zone is up to date
11-Nov-2026 17:17:50.922 client 192.168.50.11#41669: received notify for zone 'branch.example.org'
11-Nov-2026 17:17:50.922 zone branch.example.org/IN: notify from 192.168.50.11#41669: zone is up to date

# Korrektur: Seriennummer erhoehen (wieder zwischen freeze und thaw)
$ sudo rndc freeze branch.example.org
4:				2026111112 ; serial
4:				2026111113 ; serial
$ sudo rndc thaw branch.example.org
A zone reload and thaw was started.
Check the logs to see the result.
Primaer web = 192.168.50.41   Seriennummer Primaer 2026111113
Sekundaer web = 192.168.50.41   Seriennummer Sekundaer 2026111113
# Log Sekundaer (Auszug):
11-Nov-2026 17:17:59.010 transfer of 'branch.example.org/IN' from 192.168.50.11#53: Transfer status: success
11-Nov-2026 17:17:59.010 transfer of 'branch.example.org/IN' from 192.168.50.11#53: Transfer completed: 1 messages, 14 records, 455 bytes, 0.001 secs (455000 bytes/sec) (serial 2026111113)
11-Nov-2026 17:17:59.010 zone branch.example.org/IN: sending notifies (serial 2026111113)
```

## So liest du die Ausgabe

- Primär liefert `192.168.50.41`, Sekundär noch `192.168.50.40` bei **gleicher** Seriennummer.
- Im Log des Sekundärservers: `zone is up to date`. Er sieht keinen Grund, die Zone zu holen.
- Auch `rndc reload` hilft nicht (`failed: dynamic zone`).
- Nach der Korrektur zeigt das Log `Transfer status: success`, und beide Server antworten gleich.

## Selbst ausprobieren

Baue das Szenario ab: `web` zurück auf `192.168.50.40`, Seriennummer erhöhen.
