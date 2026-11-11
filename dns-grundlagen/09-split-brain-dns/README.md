# 09 Split-Brain-DNS

Übung **09.1**: Split-Horizon-Konzept, BIND-Views mit `match-clients` (alle Zonen in Views, Reihenfolge, `rndc` mit Views), Windows-DNS-Richtlinien mit Client-Subnetz, Zonenscope und Query Resolution Policy. Geschätzte Zeit: 7 bis 9 Stunden (Lehrplan: 10 UE).

> BIND-Teil real getestet (BIND 9.18.39, zweites Subnetz durch Zusatzadressen simuliert). Windows-Teil nur auf Syntax und Parameternamen geprüft.

| Datei | Zweck |
|---|---|
| `09.1-split-brain-dns-views-und-policies.md` | Die Übung |
| `09.1-named.conf.options-ausschnitt` | Änderungen für das zweite Subnetz (`listen-on`, `dmz-net`, `allow-query`) |
| `09.1-named.conf.local-views` | `named.conf.local` mit den Views `internal` und `dmz` |
| `09.1-named.conf.default-zones-leer` | Platzhalter für `named.conf.default-zones` während der View-Übung |
| `09.1-db.branch.example.org.dmz` | Zonendatei der DMZ-Sicht |
| `09.1-split-pruefen.sh` | Prüft Antworten beider Subnetze (`views` oder `ohne`) |
| `09.1-windows-zweites-subnetz.ps1` | Zusätzliche Adresse im Netz 192.168.60.0/24 (`-WhatIf`) |
| `09.1-windows-dns-policy.ps1` | Client-Subnetz, Zonenscope, Richtlinie einrichten oder mit `-Entfernen` zurücknehmen (`-WhatIf`) |
| `beispiele/` | Echte Mitschnitte: ohne/mit Views, `rndc` mit Views, Reihenfolge, Rückkehr |
