# rndc mit Views und Transfer

Zu Modul 09: [09-split-brain-dns](../09.1-split-brain-dns-views-und-policies.md). Dort steht die ausführliche Anleitung.

## Ziel

Erkennen, dass `rndc` mit Views den Namen des Views braucht, und dass Zonentransfers dem passenden View folgen.

## Voraussetzungen

- Die Zone `branch.example.org` liegt in beiden Views (`internal` und `dmz`).
- Der Sekundärserver `192.168.50.10` gehört (nach Quelladresse) zum View `internal`.

## Schritte

1. Versuche `freeze` ohne View:

   ```bash
   sudo rndc freeze branch.example.org
   ```

2. Nenne den View:

   ```bash
   sudo rndc freeze branch.example.org IN internal
   sudo rndc thaw branch.example.org IN internal
   ```

3. Prüfe die Zone im anderen View:

   ```bash
   sudo rndc zonestatus branch.example.org IN dmz | head -4
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
$ sudo rndc freeze branch.example.org
rndc: 'freeze' failed: multiple
zone 'branch.example.org' was found in multiple views
$ sudo rndc freeze branch.example.org IN internal
$ sudo rndc thaw branch.example.org IN internal
A zone reload and thaw was started.
Check the logs to see the result.
$ sudo rndc zonestatus branch.example.org IN dmz | head -4
name: branch.example.org
type: primary
files: /etc/bind/db.branch.example.org.dmz
serial: 2026111201

# Transfer zum Windows-Stellvertreter laeuft weiter (Quelle 192.168.50.10 gehoert zum View internal)
$ sudo rndc retransfer ... auf dem Sekundaerserver; Log auf SRV-LIN-BIND:
11-Nov-2026 17:06:04.338 client @0x7f077c019078 192.168.50.10#37497 (branch.example.org): view internal: transfer of 'branch.example.org/IN': AXFR started (serial 2026111110)
11-Nov-2026 17:06:04.338 client @0x7f077c019078 192.168.50.10#37497 (branch.example.org): view internal: transfer of 'branch.example.org/IN': AXFR ended: 1 messages, 14 records, 455 bytes, 0.001 secs (455000 bytes/sec) (serial 202

# nsupdate gegen den View internal
rc=0
192.168.50.81
```

## So liest du die Ausgabe

- Ohne View: `failed: multiple`, die Zone steht in mehreren Views.
- Mit `IN internal` klappt es. Die Syntax lautet `rndc <befehl> <zone> IN <view>`.
- `zonestatus … IN dmz` zeigt eine eigene Zonendatei (`db.branch.example.org.dmz`) mit eigener Seriennummer.
- Der Log-Auszug zeigt `view internal: transfer of …`: Der Transfer an `192.168.50.10` kommt aus dem View `internal`.
- `nsupdate` gegen den View `internal` funktioniert (Rückgabewert `0`), das neue Ziel ist abfragbar.

## Selbst ausprobieren

Führe `rndc reload` ohne View-Angabe aus und lies das Ergebnis.
