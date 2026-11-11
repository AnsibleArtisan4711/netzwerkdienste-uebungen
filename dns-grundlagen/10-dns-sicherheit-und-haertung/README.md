# 10 DNS-Sicherheit und Härtung

Übung **10.1**: Angriffsvektoren, Härtung von Windows-DNS (Cache Locking, Socket Pool, Response Rate Limiting) und BIND (Version verbergen, Rekursion, Cache-Zugriff, Zonentransfer, `rate-limit`), Abgrenzung DNSSEC gegen DoT/DoH. Geschätzte Zeit: 5 bis 7 Stunden (Lehrplan: 8 UE).

> BIND-Teil real getestet (BIND 9.18.39). Windows-Teil nur auf Syntax und Parameternamen geprüft.

| Datei | Zweck |
|---|---|
| `10.1-dns-sicherheit-und-haertung.md` | Die Übung |
| `10.1-named.conf.options-haertung` | `named.conf.options` mit Härtungsdirektiven |
| `10.1-bind-haertung-pruefen.sh` | Prüft Version, offene Rekursion, Transfersperre (ändert nichts) |
| `10.1-windows-haertung.ps1` | Zeigt Socket Pool, Cache Locking, RRL; `-Haerten`, `-Zuruecksetzen` (`-WhatIf`) |
| `beispiele/` | Echte Mitschnitte: Version vorher/nachher, RRL-Wirkung, offener Resolver, `allow-transfer` |
