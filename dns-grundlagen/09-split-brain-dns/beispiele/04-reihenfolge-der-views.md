# Reihenfolge der Views

Zu Modul 09: [09-split-brain-dns](../09.1-split-brain-dns-views-und-policies.md). Dort steht die ausführliche Anleitung.

## Ziel

Zeigen, dass bei überlappenden `match-clients` der **erste** passende View gewinnt.

## Voraussetzungen

- Der View `dmz` hat testweise `match-clients { 192.168.0.0/16; };` (überlappt mit `internal`).

## Schritte

1. Setze den View `dmz` **hinter** `internal` und frage aus dem internen Netz ab:

   ```bash
   sudo named-checkconf
   sudo rndc reconfig
   dig -b 192.168.50.100 +short @192.168.50.11 www.branch.example.org A
   ```

2. Vertausche die Reihenfolge (`dmz` **vor** `internal`) und frage erneut ab.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# Reihenfolge der Views: der erste passende match-clients gewinnt
# dmz-View (match-clients 192.168.0.0/16, also ueberlappend) steht HINTER internal:
$ dig -b 192.168.50.100 +short @192.168.50.11 www.branch.example.org A
192.168.50.40
# dmz-View steht jetzt VOR internal:
$ dig -b 192.168.50.100 +short @192.168.50.11 www.branch.example.org A
192.168.60.40
```

## So liest du die Ausgabe

- `dmz` hinter `internal`: Antwort `192.168.50.40` (View `internal` greift zuerst).
- `dmz` vor `internal`: dasselbe System bekommt `192.168.60.40`.
- Regel: spezifische Views nach oben, allgemeine nach unten. Danach die Konfiguration zurücksetzen.

## Selbst ausprobieren

Setze `match-clients` des DMZ-Views zurück auf `192.168.60.0/24` und wiederhole beide Abfragen.
