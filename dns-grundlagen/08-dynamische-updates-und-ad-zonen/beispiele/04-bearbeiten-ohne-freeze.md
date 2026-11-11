# Bearbeiten ohne Freeze

Zu Modul 08: [08-dynamische-updates-und-ad-zonen](../08.1-dynamische-updates-und-ad-zonen.md). Dort steht die ausführliche Anleitung.

## Ziel

Den typischen Fehler zeigen: Eine dynamische Zone von Hand bearbeiten, ohne sie vorher einzufrieren.

## Voraussetzungen

- Die dynamische Zone `branch.example.org` mit dem Eintrag `dynhost` aus dem ersten Beispiel.

## Schritte

1. **So nicht:** Hänge eine Zeile an die Zonendatei an, ohne die Seriennummer zu ändern, und lade neu:

   ```bash
   echo "hand IN A 192.168.50.78" >> /var/lib/bind/db.branch.example.org
   sudo rndc reload branch.example.org
   ```

2. Prüfe, ob der Eintrag existiert:

   ```bash
   dig @192.168.50.11 hand.branch.example.org A +noall +comments | grep -o "status: [A-Z]*"
   ```

3. Friere die Zone ein, damit BIND die Journaländerungen in die Datei schreibt, und gib sie danach mit `thaw` wieder frei:

   ```bash
   sudo rndc freeze branch.example.org
   sudo rndc thaw branch.example.org
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# Falsch: Zonendatei einer dynamischen Zone ohne freeze bearbeiten
$ echo "hand IN A 192.168.50.78" >> /var/lib/bind/db.branch.example.org   # Seriennummer NICHT geaendert
$ sudo rndc reload branch.example.org
rndc: 'reload' failed: dynamic zone
$ dig @192.168.50.11 hand.branch.example.org A +noall +comments | grep -o "status: [A-Z]*"
status: NXDOMAIN
$ dig @192.168.50.11 dynhost.branch.example.org A +short
192.168.50.77
# Logmeldungen zur Zone:
11-Nov-2026 16:52:28.706 client @0x7f588d3a5ac8 192.168.50.11#50380/key ddns-key: updating zone 'branch.example.org/IN': adding an RR at 'dynhost.branch.example.org' A 192.168.50.77
11-Nov-2026 16:52:28.706 zone branch.example.org/IN: sending notifies (serial 2026111105)
11-Nov-2026 16:52:28.710 client @0x7f5884038c98 192.168.50.10#45947 (branch.example.org): transfer of 'branch.example.org/IN': IXFR started (serial 2026111104 -> 2026111105)
11-Nov-2026 16:52:28.710 client @0x7f5884038c98 192.168.50.10#45947 (branch.example.org): transfer of 'branch.example.org/IN': IXFR ended: 1 messages, 5 records, 225 bytes, 0.001 secs (225000 bytes/sec) (serial 2026111105)
11-Nov-2026 16:52:35.830 client @0x7f588400adc8 192.168.50.11#60035: update 'branch.example.org/IN' denied
11-Nov-2026 16:52:42.374 received control channel command 'reload branch.example.org'
$ sudo rndc freeze branch.example.org
$ grep -n "dynhost\|^hand" /var/lib/bind/db.branch.example.org   # nach dem Einfrieren
17:dynhost			A	192.168.50.77
$ ls -l /var/lib/bind
-rw-r--r-- 1 bind bind 657 Nov 11 16:52 db.branch.example.org
-rw-r--r-- 1 bind bind 804 Nov 11 16:52 db.branch.example.org.jnl
$ sudo rndc thaw branch.example.org
A zone reload and thaw was started.
Check the logs to see the result.
```

## So liest du die Ausgabe

- `rndc reload` meldet `failed: dynamic zone`. BIND verweigert das Neuladen, weil die Datei sonst Änderungen aus dem Journal überschreiben würde.
- `hand` bleibt `NXDOMAIN`: Die Handänderung ist wirkungslos. Der dynamische Eintrag `dynhost` ist weiter vorhanden.
- Nach `freeze` steht `dynhost` in der Zonendatei und die Datei ist kleiner, weil BIND sie neu schreibt.
- Die Logzeilen zeigen die Update-Kette: `updating zone … adding an RR`, `sending notifies`, `IXFR` zum Sekundärserver, `update … denied` für eine nicht signierte Anfrage.

## Selbst ausprobieren

Mache dieselben Schritte in der richtigen Reihenfolge, siehe nächstes Beispiel.
