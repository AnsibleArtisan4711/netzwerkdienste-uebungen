# Migration und TTL

Zu Modul 07: [07-weiterleitungen-und-caching](../07.1-weiterleitungen-und-caching.md). Dort steht die ausführliche Anleitung.

## Ziel

Erkennen, warum eine hohe TTL bei einer Migration stört, und wie man den Cache gezielt umgeht.

## Voraussetzungen

- Ein Eintrag `migrate.partner.example.net` mit TTL `86400` (ein Tag) und der Adresse `192.168.50.60`.
- Der weiterleitende Server (`192.168.50.10`) hat den Eintrag bereits im Cache.

## Schritte

1. Fülle den Cache des weiterleitenden Servers:

   ```bash
   dig +noall +answer @192.168.50.10 migrate.partner.example.net A
   ```

2. Ändere den Eintrag auf dem Ursprungsserver (TTL `300`, neue Adresse `192.168.50.61`), erhöhe die Seriennummer und lade neu:

   ```bash
   sudo rndc reload partner.example.net
   ```

3. Frage Ursprungsserver und weiterleitenden Server ab und vergleiche:

   ```bash
   dig +noall +answer @192.168.50.11 migrate.partner.example.net A
   dig +noall +answer @192.168.50.10 migrate.partner.example.net A
   ```

4. Entferne den Eintrag aus dem Cache des weiterleitenden Servers und frage erneut.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus. Der Windows-Server wurde im Test durch eine zweite BIND-Instanz ersetzt. **Echte Windows-Ausgaben können abweichen.**

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

## So liest du die Ausgabe

- Der Ursprungsserver liefert sofort die neue Adresse, der Cache aber weiter die **alte mit TTL 86397**.
- Jeder Client, der den Cache benutzt, landet bis zu 24 Stunden auf dem alten Ziel.
- Deshalb: **TTL vor einer Migration rechtzeitig senken.** Auf Windows leert `Clear-DnsServerCache` den ganzen Cache, bei BIND einen einzelnen Namen `rndc flushname`.

## Selbst ausprobieren

Senke die TTL einen Tag vor der Änderung und prüfe dann, ob der Cache schneller aufholt.
