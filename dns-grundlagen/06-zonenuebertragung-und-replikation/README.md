# 06 Zonenübertragung und Replikation

Übung **06.1**: AXFR, IXFR und NOTIFY, Windows als Primär- und BIND als Sekundärserver und umgekehrt, Beschränkung auf bestimmte Adressen, TSIG-gesicherte Übertragung (nur BIND), manuelles Auslösen und Fehler lesen. Geschätzte Zeit: 7 bis 9 Stunden (Lehrplan: 10 UE).

> BIND-Teil real getestet (BIND 9.18.39; ein zweites BIND vertrat den Windows-Server). Windows-Teil nur auf Syntax geprüft. Hinweis zum Lehrplan: `Sync-DnsServerZone` löst keine Übertragung aus.

| Datei | Zweck |
|---|---|
| `06.1-zonenuebertragung-und-replikation.md` | Die Übung |
| `06.1-db.branch.example.org` | Zonendatei `branch.example.org` (Primär auf BIND) |
| `06.1-named.conf.local` | Vorlage für die Zonendefinitionen auf SRV-LIN-BIND |
| `06.1-db.tsig-test.example.org` | Testzone für die TSIG-Übung |
| `06.1-windows-primaer-freigeben.ps1` | Übertragung und NOTIFY auf Windows freigeben (`-WhatIf`) |
| `06.1-windows-sekundaer-anlegen.ps1` | Sekundärzone auf Windows anlegen (`-WhatIf`) |
| `06.1-transfer-pruefen.sh` | Prüft Seriennummern und abgelehnte Abzüge |
| `beispiele/` | Echte Logs und Abzüge (der TSIG-Schlüssel ist geschwärzt) |
