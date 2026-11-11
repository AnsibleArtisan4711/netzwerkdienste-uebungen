# 05 Resource Records und Reverse-Zonen

Übung **05.1**: Aufbau von Resource Records (A, AAAA, CNAME, MX, TXT, SRV, PTR), Forward-Einträge auf Windows, Reverse-Zonen berechnen und anlegen (IPv4 und IPv6), Einträge in BIND, Zonendatei-Syntax und typische Fehler. Geschätzte Zeit: 8 bis 10 Stunden (Lehrplan: 12 UE).

> BIND-Teil real getestet (BIND 9.18.39). Windows-Teil nur auf Syntax geprüft.

| Datei | Zweck |
|---|---|
| `05.1-resource-records-und-reverse-zonen.md` | Die Übung |
| `05.1-db.corp.example.com` | Vergleichsdatei: die Einträge von `corp.example.com` als BIND-Zonendatei |
| `05.1-db.branch.example.org` | Zonendatei `branch.example.org` für BIND |
| `05.1-db.50.168.192.in-addr.arpa` | IPv4-Reverse-Zone |
| `05.1-db.0.0.0.0.0.0.0.0.0.5.0.0.0.0.d.f.ip6.arpa` | IPv6-Reverse-Zone |
| `05.1-origin-beispiel.txt` | Beispiel zu `$ORIGIN` und leeren Namensfeldern (mit `named-checkzone -D`) |
| `05.1-corp-records-anlegen.ps1` | Legt die Einträge von `corp.example.com` auf Windows an (`-WhatIf`) |
| `05.1-reverse-zonen-anlegen.ps1` | Legt Reverse-Zonen und PTR-Einträge auf Windows an (`-WhatIf`) |
| `05.1-records-testen.ps1` | Fragt von `CLI-TEST-01` alle Eintragstypen bei beiden Servern ab |
| `05.1-records-pruefen.sh` | Prüft die Einträge von `branch.example.org` auf SRV-LIN-BIND |
| `beispiele/` | Echte Mitschnitte der BIND-Abfragen |
