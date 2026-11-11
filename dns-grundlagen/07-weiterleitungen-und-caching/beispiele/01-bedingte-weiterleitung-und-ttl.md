# Bedingte Weiterleitung und TTL

Zu Modul 07: [07-weiterleitungen-und-caching](../07.1-weiterleitungen-und-caching.md). Dort steht die ausführliche Anleitung.

## Ziel

Eine bedingte Weiterleitung prüfen und an der sinkenden TTL erkennen, dass die Antwort aus dem Cache kommt.

## Voraussetzungen

- Auf dem weiterleitenden Server (hier `192.168.50.10`) ist eine bedingte Weiterleitung für `partner.example.net` auf `192.168.50.11` eingerichtet.
- Der Cache wurde vorher geleert. Im Test war der Server eine BIND-Instanz als Stellvertreter für SRV-WIN-DNS.

## Schritte

1. Frage den weiterleitenden Server ab:

   ```bash
   dig @192.168.50.10 portal.partner.example.net A
   ```

2. Warte etwa 15 Sekunden und wiederhole die Abfrage.
3. Frage zum Vergleich den Ursprungsserver:

   ```bash
   dig @192.168.50.11 portal.partner.example.net A
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus. Der Windows-Server wurde im Test durch eine zweite BIND-Instanz ersetzt. **Echte Windows-Ausgaben können abweichen.**

```text
# Bedingte Weiterleitung: Abfrage ueber den Windows-Server (Stellvertreter 192.168.50.10)
# Weiterleitung nur fuer partner.example.net auf 192.168.50.11; Cache vorher geleert
$ dig @192.168.50.10 portal.partner.example.net A
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; ANSWER SECTION:
portal.partner.example.net. 3600 IN	A	192.168.50.88


# 15 Sekunden spaeter (Antwort aus dem Cache, TTL gesunken)
$ dig @192.168.50.10 portal.partner.example.net A
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; ANSWER SECTION:
portal.partner.example.net. 3585 IN	A	192.168.50.88


# Zum Vergleich der Ursprungsserver: autoritativ (aa), volle TTL
$ dig @192.168.50.11 portal.partner.example.net A
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; ANSWER SECTION:
portal.partner.example.net. 3600 IN	A	192.168.50.88
```

## So liest du die Ausgabe

- Erste Antwort: TTL `3600`, `flags: qr rd ra`, **kein** `aa`, denn der Server leitet nur weiter.
- Zweite Antwort: TTL `3585`, die Zahl sinkt. Die Antwort kommt aus dem Cache.
- Der Ursprungsserver liefert `aa` und immer die volle TTL.
- Windows-Ausgaben sind in diesem Modul *nicht bestätigt*: Die Spalte der TTL kann bei `Resolve-DnsName` anders aussehen.

## Selbst ausprobieren

Leere den Cache und beobachte, dass die TTL wieder bei der vollen Zahl beginnt.
