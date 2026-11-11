# Nach der Rückkehr

Zu Modul 09: [09-split-brain-dns](../09.1-split-brain-dns-views-und-policies.md). Dort steht die ausführliche Anleitung.

## Ziel

Kontrollieren, dass nach der Rückkehr zur Konfiguration ohne Views wieder beide Netze dieselbe Antwort bekommen.

## Voraussetzungen

- Die Konfiguration ohne Views wurde wiederhergestellt (Sicherung zurückkopieren, `named-checkconf`, `rndc reconfig`).

## Schritte

1. Frage aus dem zweiten Netz ab:

   ```bash
   dig -b 192.168.60.100 +short @192.168.60.11 www.branch.example.org A
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
$ dig -b 192.168.60.100 +short @192.168.60.11 www.branch.example.org A   # nach der Rueckkehr zur Konfiguration ohne Views
web.branch.example.org.
192.168.50.40
```

## So liest du die Ausgabe

- Die Antwort ist wieder `192.168.50.40`, wie vor den Views (Beispiel `01-ohne-views`).
- So belegst du, dass der Rückbau vollständig war.

## Selbst ausprobieren

Führe zum Schluss `sudo named-checkconf` und `sudo rndc status` aus.
