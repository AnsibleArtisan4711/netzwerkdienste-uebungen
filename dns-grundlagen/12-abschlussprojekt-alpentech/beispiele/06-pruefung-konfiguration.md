# Prüfung der Konfiguration

Zu Modul 12: [12-abschlussprojekt-alpentech](../12.1-abschlussprojekt-alpentech.md). Dort steht die ausführliche Anleitung.

## Ziel

Konfiguration und Zonen vor der Abnahme prüfen: Syntax, Zonendatei, Sekundärstatus, SOA.

## Voraussetzungen

- SRV-LIN-BIND ist Primär für `dev.alpentech.internal` und Sekundär für `hq.alpentech.internal`.

## Schritte

1. Prüfe die Konfiguration und eine Zonendatei:

   ```bash
   sudo named-checkconf
   sudo named-checkzone dev.alpentech.internal /etc/bind/db.dev.alpentech.internal
   ```

2. Prüfe die Sekundärzone:

   ```bash
   sudo rndc zonestatus hq.alpentech.internal | grep -E "type|serial|next refresh|expires"
   ```

3. Vergleiche die SOA-Daten beider Zonen:

   ```bash
   dig +short @192.168.50.11 hq.alpentech.internal SOA
   dig +short @192.168.50.11 dev.alpentech.internal SOA
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
$ sudo named-checkconf
(keine Ausgabe = fehlerfrei)
$ sudo named-checkzone dev.alpentech.internal /etc/bind/db.dev.alpentech.internal
zone dev.alpentech.internal/IN: dev.alpentech.internal/MX 'mail.hq.alpentech.internal' (out of zone) has no addresses records (A or AAAA)
zone dev.alpentech.internal/IN: loaded serial 2026111201
OK
$ sudo rndc zonestatus hq.alpentech.internal | grep -E "type|serial|next refresh|expires"
type: secondary
serial: 2026111201
next refresh: Wed, 11 Nov 2026 16:44:04 GMT
expires: Wed, 18 Nov 2026 16:29:30 GMT
$ dig +short @192.168.50.11 hq.alpentech.internal SOA
ns1.hq.alpentech.internal. hostmaster.hq.alpentech.internal. 2026111201 900 300 604800 3600
$ dig +short @192.168.50.11 dev.alpentech.internal SOA
ns1.dev.alpentech.internal. hostmaster.dev.alpentech.internal. 2026111201 900 300 604800 3600
```

## So liest du die Ausgabe

- `named-checkconf` ohne Ausgabe: fehlerfrei.
- `named-checkzone` meldet `OK` und die Seriennummer. Die Zeile `MX … (out of zone) has no addresses records` ist eine **Warnung**: Der Mailserver liegt in einer anderen Zone, die Prüfung kann ihn nicht sehen.
- `type: secondary` und `expires` zeigen, wann die Sekundärzone ohne Verbindung zum Primär ungültig würde (hier 7 Tage nach der letzten Aktualisierung).
- Gleiche Seriennummer auf beiden SOA-Abfragen: Zonen sind synchron.

## Selbst ausprobieren

Füge einen Syntaxfehler in eine Kopie der Zonendatei ein und prüfe, was `named-checkzone` meldet.
