# DNS-Grundlagen: Übungsreihe (Windows-DNS und BIND)

Praktische Übungen zum Lehrplan **P01 DNS-Grundlagen (Windows-DNS und BIND)**. Diese Fassung deckt alle **12 Module** ab (112 UE).

**Status: Entwurf.** Nicht alles ist geprüft; jede Übung nennt ihren Teststand in einem Warnhinweis.

## Module

| Modul | Thema | Übung |
|---|---|---|
| [01](01-namensaufloesung-und-dns-architektur/) | Namensauflösung und DNS-Architektur | 01.1 |
| [02](02-windows-dns-server/) | Windows-DNS-Server | 02.1 |
| [03](03-bind-9-unter-linux/) | BIND 9 unter Linux | 03.1 |
| [04](04-zonentypen/) | Zonentypen im Detail | 04.1 |
| [05](05-resource-records-und-reverse-zonen/) | Resource Records und Reverse-Zonen | 05.1 |
| [06](06-zonenuebertragung-und-replikation/) | Zonenübertragung und Replikation | 06.1 |
| [07](07-weiterleitungen-und-caching/) | Weiterleitungen und Caching | 07.1 |
| [08](08-dynamische-updates-und-ad-zonen/) | Dynamische Updates und AD-integrierte Zonen | 08.1 |
| [09](09-split-brain-dns/) | Split-Brain-DNS, BIND Views und Windows DNS Policies | 09.1 |
| [10](10-dns-sicherheit-und-haertung/) | DNS-Sicherheit, Härtung und Abgrenzung zu DNSSEC | 10.1 |
| [11](11-fehlersuche-und-monitoring/) | Fehlersuche, Diagnose und Monitoring | 11.1 |
| [12](12-abschlussprojekt-alpentech/) | Abschlussprojekt: Hybride DNS-Infrastruktur AlpenTech | 12.1 |

## Labor

Alle Übungen laufen in einem isolierten Hyper-V-Labor ohne Verbindung zu produktiven Netzen.

| Element | Wert |
|---|---|
| Switch | privat, `vSwitch-DNS-Lab` |
| Netz | 192.168.50.0/24, IPv6 `fd00:50::/64`; ab Modul 9 zusätzlich ein simuliertes zweites Netz 192.168.60.0/24 |
| `SRV-WIN-DNS` | Windows Server, 192.168.50.10 |
| `SRV-LIN-BIND` | Debian 12 oder Ubuntu 24.04 mit BIND 9, 192.168.50.11 |
| `CLI-TEST-01` | Windows-Client, 192.168.50.100 |
| Domänen | `corp.example.com`, `branch.example.org`, `lab.internal`; Modul 12: `hq.alpentech.internal`, `dev.alpentech.internal` |

Vor jedem Modul einen Snapshot anlegen (`m01-ende` usw.).

## Was geprüft wurde

- **BIND/Linux:** alle Befehle und Ausgaben aus einem echten Lauf (Ubuntu 24.04, BIND 9.18.39, Testumgebung ohne systemd, AppArmor, IPv6 und Internet). Nicht geprüft: `journalctl`, AppArmor, `dig +trace`, Verhalten bei Weiterleitungsschleifen.
- **Windows:** nicht ausgeführt. In den Modulen 7, 9, 11 und 12 vertrat eine zweite BIND-Instanz auf 192.168.50.10 den Windows-Server (Cache- und Weiterleitungsverhalten, Ausfallsimulation, Zonenübertragungen); Heraufstufung, AD-Zonen, Aging, DNS-Richtlinien, Windows-Härtung und Windows-Diagnose sind ungetestet. Cmdlets und Parameter wurden gegen Microsoft Learn geprüft, PowerShell-Skripte mit PowerShell 7.4.6 auf Syntax. Unsichere Stellen sind im Text mit „nicht bestätigt“ oder „sinngemäß“ markiert.

## Sicherheit

Die Übungen ändern DNS-, hosts- und Firewall-Einstellungen. Nur im Labor ausführen, nie auf produktiven Servern. Skripte, die Systemdateien ändern, haben `-WhatIf` bzw. legen ein Backup an.

## Lizenz

Skripte und Konfigurationsdateien: MIT ([LICENSE](LICENSE)). Texte: CC BY 4.0 ([LICENSE-DOCS.md](LICENSE-DOCS.md)).
