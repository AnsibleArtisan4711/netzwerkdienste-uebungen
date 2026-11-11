# Freeze, bearbeiten, Thaw

Zu Modul 08: [08-dynamische-updates-und-ad-zonen](../08.1-dynamische-updates-und-ad-zonen.md). Dort steht die ausführliche Anleitung.

## Ziel

Eine dynamische Zone richtig von Hand bearbeiten: `freeze`, bearbeiten, Seriennummer erhöhen, `thaw`.

## Voraussetzungen

- Dieselbe Zone wie im vorigen Beispiel.

## Schritte

1. Friere die Zone ein:

   ```bash
   sudo rndc freeze branch.example.org
   ```

2. Erhöhe die Seriennummer und füge den Eintrag hinzu:

   ```bash
   sudo sed -i "s/2026111105/2026111106/" /var/lib/bind/db.branch.example.org
   echo "hand IN A 192.168.50.78" | sudo tee -a /var/lib/bind/db.branch.example.org
   ```

3. Prüfe die Datei, **bevor** du sie freigibst:

   ```bash
   sudo named-checkzone branch.example.org /var/lib/bind/db.branch.example.org
   ```

4. Gib die Zone mit `thaw` wieder frei und prüfe das Ergebnis:

   ```bash
   sudo rndc thaw branch.example.org
   dig @192.168.50.11 hand.branch.example.org A +short
   dig @192.168.50.11 dynhost.branch.example.org A +short
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# Richtig: freeze, bearbeiten, Seriennummer erhoehen, thaw
$ sudo rndc freeze branch.example.org
$ sudo sed -i "s/2026111105/2026111106/" /var/lib/bind/db.branch.example.org
$ echo "hand IN A 192.168.50.78" | sudo tee -a /var/lib/bind/db.branch.example.org
$ sudo named-checkzone branch.example.org /var/lib/bind/db.branch.example.org
zone branch.example.org/IN: loaded serial 2026111106
OK
$ sudo rndc thaw branch.example.org
A zone reload and thaw was started.
Check the logs to see the result.
$ dig @192.168.50.11 hand.branch.example.org A +short
192.168.50.78
$ dig @192.168.50.11 dynhost.branch.example.org A +short   # dynamischer Eintrag bleibt erhalten
192.168.50.77
$ dig @192.168.50.11 branch.example.org SOA +short
linserver.branch.example.org. hostmaster.branch.example.org. 2026111106 900 300 604800 3600
$ ls -l /var/lib/bind
-rw-r--r-- 1 bind bind 681 Nov 11 16:52 db.branch.example.org
# Log:
11-Nov-2026 16:52:58.154 zone branch.example.org/IN: journal file is out of date: removing journal file
11-Nov-2026 16:52:58.154 zone branch.example.org/IN: loaded serial 2026111106
11-Nov-2026 16:52:58.154 zone branch.example.org/IN: sending notifies (serial 2026111106)
11-Nov-2026 16:52:58.154 client @0x7f588d3618c8 192.168.50.10#38689 (branch.example.org): transfer of 'branch.example.org/IN': IXFR version not in journal, falling back to AXFR
11-Nov-2026 16:52:58.154 client @0x7f588d3618c8 192.168.50.10#38689 (branch.example.org): transfer of 'branch.example.org/IN': AXFR-style IXFR started (serial 2026111106)
11-Nov-2026 16:52:58.154 client @0x7f588d3618c8 192.168.50.10#38689 (branch.example.org): transfer of 'branch.example.org/IN': AXFR-style IXFR ended: 1 messages, 14 records, 458 bytes, 0.001 secs (458000 bytes/sec) (serial 2026111106)
```

## So liest du die Ausgabe

- `named-checkzone` meldet `OK`. Erst dann `thaw`.
- Beide Einträge sind abfragbar, der dynamische (`dynhost`) und der von Hand (`hand`).
- Im Log steht `journal file is out of date: removing journal file`: Das Journal wird durch die neue Datei ersetzt.
- Der Sekundärserver holt die Zone danach per AXFR (`IXFR version not in journal`), weil das Journal fehlt.

## Selbst ausprobieren

Lasse die Seriennummer stehen und beobachte, dass der Sekundärserver die Änderung nicht übernimmt (Modul 6).
