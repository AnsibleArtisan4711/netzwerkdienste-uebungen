# 01 Namensauflösung und DNS-Architektur

Übung **01.1**: Labor aufbauen, hosts-Datei und Auflösungsreihenfolge, Namensraum und Grenzen, Rollen im DNS, sieben echte `dig`-Ausgaben lesen. Geschätzte Zeit: 6 Stunden (Lehrplan: 8 UE).

| Datei | Zweck |
|---|---|
| `01.1-namensaufloesung-und-dns-architektur.md` | Die Übung (Aufgabe, Hinweise, Musterlösung) |
| `01.1-hosts-eintragen.ps1` | Trägt Testeinträge mit Marker in die hosts-Datei ein (`-WhatIf`, Backup) |
| `01.1-hosts-aufraeumen.ps1` | Entfernt nur die markierten Einträge wieder |
| `01.1-labor-pruefen.sh` | Prüft auf SRV-LIN-BIND Adresse, Name, Erreichbarkeit |
| `beispiele/` | Sieben echte `dig`-Ausgaben (NOERROR, NXDOMAIN, NODATA, SERVFAIL, TC, TCP, REFUSED) |
