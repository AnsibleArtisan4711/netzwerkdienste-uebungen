# 08 Dynamische Updates und AD-integrierte Zonen

Übung **08.1**: Dynamische Updates (RFC 2136), Active Directory und DNS (`_msdcs`, AD-integrierte Zonen, sichere Updates), Aging und Scavenging unter Windows, TSIG, `nsupdate`, Journal und `rndc freeze`/`thaw` unter BIND. Geschätzte Zeit: 8 bis 10 Stunden (Lehrplan: 10 UE).

> BIND-Teil real getestet (BIND 9.18.39). **Der Windows-Teil (Heraufstufung, AD-Zonen, Aging) wurde nicht ausgeführt**; die Skripte sind nur auf Syntax und Parameternamen geprüft. Die Heraufstufung zum Domänencontroller ist im Labor nur mit Snapshot ratsam.

| Datei | Zweck |
|---|---|
| `08.1-dynamische-updates-und-ad-zonen.md` | Die Übung |
| `08.1-named.conf.local-ausschnitt` | Konfigurationsausschnitt für BIND (Schlüssel, Zone, `allow-update`) |
| `08.1-nsupdate-dynhost.txt` | Befehlsdatei für `nsupdate` |
| `08.1-ddns-pruefen.sh` | Prüft Schlüsselrechte, Zonenstatus und Update mit/ohne Schlüssel |
| `08.1-windows-vor-heraufstufung.ps1` | Bereitet die Zone und Netzwerkkarte vor der Heraufstufung vor (`-WhatIf`) |
| `08.1-windows-ad-zonen-umwandeln.ps1` | Wandelt Zonen in AD-integrierte um, setzt sichere Updates, erhält die Übertragung an BIND (`-WhatIf`) |
| `08.1-windows-aging-einrichten.ps1` | Aging und Scavenging einschalten, Zeitstempel anzeigen (`-WhatIf`) |
| `08.1-windows-client-registrierung.ps1` | Registrierung des Clients auslösen und prüfen |
| `beispiele/` | Echte Mitschnitte: Update, Ablehnung, Journal, Bearbeiten mit und ohne `freeze`, `update-policy` (das Geheimnis des Schlüssels kommt nirgends vor) |
