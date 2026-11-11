# Bedingte Weiterleitung und TTL

Beispielausgabe zu Modul 07 (`07-weiterleitungen-und-caching`). Der Inhalt des Blocks ist unverändert.

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
