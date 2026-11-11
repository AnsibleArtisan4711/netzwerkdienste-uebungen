# Ohne Views

Zu Modul 09: [09-split-brain-dns](../09.1-split-brain-dns-views-und-policies.md). Dort steht die ausführliche Anleitung.

## Ziel

Den Ausgangszustand dokumentieren: Ohne Views bekommen beide Netze dieselbe Antwort.

## Voraussetzungen

- Das zweite Subnetz `192.168.60.0/24` ist eingerichtet (simuliert, Modul 9), SRV-LIN-BIND ist unter `192.168.50.11` und `192.168.60.11` erreichbar.
- Eine Konfiguration **ohne** Views.

## Schritte

1. Frage aus dem internen Netz ab (`-b` setzt die Absenderadresse):

   ```bash
   dig -b 192.168.50.100 +short @192.168.50.11 www.branch.example.org A
   ```

2. Frage aus dem zweiten Netz an der `.60`-Adresse des Servers ab:

   ```bash
   dig -b 192.168.60.100 +short @192.168.60.11 www.branch.example.org A
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# Vor den Views: dieselbe Antwort fuer beide Subnetze
$ dig -b 192.168.50.100 +short @192.168.50.11 www.branch.example.org A
web.branch.example.org.
192.168.50.40
$ dig -b 192.168.60.100 +short @192.168.60.11 www.branch.example.org A
web.branch.example.org.
192.168.50.40
```

## So liest du die Ausgabe

- Beide Netze erhalten `192.168.50.40`: Dem zweiten Netz wird also die interne Adresse genannt.
- Das ist der Grund für Split-Brain-DNS: gleiche Frage, andere Antwort je nach Quelle.

## Selbst ausprobieren

Notiere die beiden Antworten, bevor du Views einschaltest, und vergleiche danach.
