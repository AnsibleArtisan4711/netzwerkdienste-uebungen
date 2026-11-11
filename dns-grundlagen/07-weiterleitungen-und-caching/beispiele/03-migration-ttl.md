# Migration und TTL

Beispielausgabe zu Modul 07 (`07-weiterleitungen-und-caching`). Der Inhalt des Blocks ist unverändert.

```text
# Migration: alte TTL 86400, Eintrag wird auf Primaer geaendert, Windows-Cache bleibt veraltet
$ dig +noall +answer @192.168.50.10 migrate.partner.example.net A      # Cache gefuellt (alte TTL 86400)
migrate.partner.example.net. 86400 IN	A	192.168.50.60

# Auf SRV-LIN-BIND: Eintrag auf 300 / 192.168.50.61 geaendert, Seriennummer erhoeht, rndc reload
zone reload queued
$ dig +noall +answer @192.168.50.11 migrate.partner.example.net A      # Ursprungsserver
migrate.partner.example.net. 300 IN	A	192.168.50.61
$ dig +noall +answer @192.168.50.10 migrate.partner.example.net A      # Windows-Cache: noch alt!
migrate.partner.example.net. 86397 IN	A	192.168.50.60

# Gezielt vergessen (BIND: rndc flushname; Windows: Clear-DnsServerCache leert den ganzen Cache)
$ dig +noall +answer @192.168.50.10 migrate.partner.example.net A
migrate.partner.example.net. 300 IN	A	192.168.50.61
```
