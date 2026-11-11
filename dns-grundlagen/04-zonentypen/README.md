# 04 Zonentypen im Detail

Übung **04.1**: Zone und Delegation, Glue, Zonentypen, SOA-Felder, primäre Zonen unter Windows und BIND, typische Zonendatei-Fehler. Geschätzte Zeit: 7 bis 9 Stunden (Lehrplan: 10 UE).

> BIND-Teil real getestet (BIND 9.18.39). Windows-Teil nur auf Syntax geprüft.

| Datei | Zweck |
|---|---|
| `04.1-zonentypen-und-primaere-zonen.md` | Die Übung |
| `04.1-corp-zone-anlegen.ps1` | Legt `corp.example.com` samt SOA-Werten und A-Eintrag an (`-WhatIf`) |
| `04.1-db.branch.example.org` | Fertige Zonendatei für BIND |
| `04.1-zone-pruefen.sh` | Prüft Zone, SOA, Seriennummer, NS und A |
