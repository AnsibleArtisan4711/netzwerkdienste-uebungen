# 07 Weiterleitungen und Caching

Übung **07.1**: Forwarder und Root Hints, `forward first`/`forward only`, bedingte Weiterleitung (Windows und BIND), Stub-Zone im Vergleich, positives und negatives Caching, Migration mit abgesenkter TTL, Cache anzeigen und leeren. Geschätzte Zeit: 5 bis 7 Stunden (Lehrplan: 8 UE).

> BIND-Teil real getestet (BIND 9.18.39; ein zweites BIND vertrat den Windows-Server). Windows-Teil nur auf Syntax geprüft. Nicht gemessen: Zeitverhalten bei totem Weiterleitungsserver, Stub-Zonen.

| Datei | Zweck |
|---|---|
| `07.1-weiterleitungen-und-caching.md` | Die Übung |
| `07.1-db.partner.example.net` | Zonendatei der Partnerfirma für BIND |
| `07.1-windows-weiterleitungen-einrichten.ps1` | Bedingte Weiterleitung und optional `lab.internal` auf Windows (`-WhatIf`) |
| `07.1-windows-cache-pruefen.ps1` | Server- und Client-Cache anzeigen, auf Wunsch leeren (`-WhatIf`) |
| `07.1-weiterleitung-pruefen.sh` | Prüft Weiterleitung, Autoritativ-Flag und negative TTL |
| `beispiele/` | Echte Mitschnitte: TTL-Countdown, negatives Caching, Migration, Cache-Dump, DNSSEC-Stolperstein |
