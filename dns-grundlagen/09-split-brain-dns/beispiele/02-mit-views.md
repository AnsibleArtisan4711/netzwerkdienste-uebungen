# Mit Views

Zu Modul 09: [09-split-brain-dns](../09.1-split-brain-dns-views-und-policies.md). Dort steht die ausführliche Anleitung.

## Ziel

Prüfen, dass der Server je nach Quelladresse unterschiedlich antwortet, und was im DMZ-View fehlt oder verboten ist.

## Voraussetzungen

- Die Views `internal` und `dmz` aus Modul 9 sind konfiguriert (`09.1-named.conf.local-views`).
- Zweites Subnetz wie im vorigen Beispiel.

## Schritte

1. Gleiche Frage aus beiden Netzen:

   ```bash
   dig -b 192.168.50.100 +short @192.168.50.11 www.branch.example.org A
   dig -b 192.168.60.100 +short @192.168.60.11 www.branch.example.org A
   ```

2. Frage im DMZ-View etwas, das es dort nicht geben soll:

   ```bash
   dig -b 192.168.60.100 @192.168.60.11 linserver.branch.example.org AAAA +short
   dig -b 192.168.60.100 @192.168.60.11 corp.example.com SOA
   dig -b 192.168.60.100 @192.168.60.11 www.example.org A
   ```

3. Frage aus dem internen Netz die `.60`-Adresse ab:

   ```bash
   dig -b 192.168.50.100 @192.168.60.11 corp.example.com SOA +short
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# Mit Views: gleiche Frage, andere Antwort je nach Quelladresse
$ dig -b 192.168.50.100 +short @192.168.50.11 www.branch.example.org A     # Quelle im internen Netz
web.branch.example.org.
192.168.50.40
$ dig -b 192.168.60.100 +short @192.168.60.11 www.branch.example.org A     # Quelle im DMZ-Netz
web.branch.example.org.
192.168.60.40
$ dig -b 192.168.60.100 @192.168.60.11 linserver.branch.example.org AAAA +short   # im DMZ-View nicht vorhanden
(leer)
$ dig -b 192.168.60.100 @192.168.60.11 corp.example.com SOA     # Zone gibt es im DMZ-View nicht
status: REFUSED
flags: qr rd
$ dig -b 192.168.60.100 @192.168.60.11 www.example.org A     # Rekursion im DMZ-View verboten
status: REFUSED
flags: qr rd
$ dig -b 192.168.50.100 @192.168.60.11 corp.example.com SOA +short   # internes Netz fragt die .60-Adresse
winserver.corp.example.com. hostmaster.corp.example.com. 2026111103 900 300 604800 3600
```

## So liest du die Ausgabe

- Intern `192.168.50.40`, DMZ `192.168.60.40`: Die Antwort richtet sich nach der Quelladresse.
- `linserver … AAAA` im DMZ-View: leer, der Name steht dort nicht in der Zone.
- `corp.example.com`: `REFUSED`, weil die Zone im DMZ-View nicht existiert.
- `www.example.org`: `REFUSED`, weil Rekursion im DMZ-View verboten ist (`flags: qr rd`).
- Fragt das **interne** Netz die `.60`-Adresse, gehört es weiterhin zum View `internal` (Zuordnung nach Quelladresse, nicht nach Zieladresse).

## Selbst ausprobieren

Ändere die Adresse von `www` im DMZ-View und lade neu. Prüfe beide Antworten.
