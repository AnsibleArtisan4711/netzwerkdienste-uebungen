# DHCP: Grundlagen und Betrieb (P71)

Übungsreihe zum Lehrplan **P71 – DHCP, Grundlagen und Betrieb**: zwölf Module mit je einer ausgearbeiteten Übung (Lernziele, Aufgabe mit grafischer Oberfläche und PowerShell bzw. Linux-Befehlen, Hintergrund, Kontrollfragen, Erweiterungen, Musterlösung, Aufräumen, Quellen), Skripten und Konfigurationen. Gesamtumfang: 81 Stunden (108 Unterrichtseinheiten zu 45 Minuten).

> **Prüfstand, ehrlich:** Der Linux-Teil (Kea 2.4.1, `isc-dhcp-relay` 4.4.3-P1, `dhclient`, `tcpdump`, Skripte) wurde in einer Testumgebung aus Netzwerk-Namespaces unter Ubuntu 24.04 real ausgeführt. **Kein Windows-Befehl wurde ausgeführt**, IPv6 (Modul 9) nur auf Syntax geprüft, Hyper-V nicht verwendet. Jedes Modul nennt seinen Stand im Warnhinweis. Offene Punkte: [`befehle-nicht-bestaetigt.md`](befehle-nicht-bestaetigt.md); Anmerkungen zum Lehrplan: [`lehrplan-korrekturen.md`](lehrplan-korrekturen.md).

## Laborumgebung

Hyper-V mit drei **privaten** Switches. Alle Namen und Adressen sind Beispielwerte (Domäne `corp.example.com`).

| Switch | Netz |
|---|---|
| `vSwitch-Server` | `192.168.10.0/24` (Netz A) |
| `vSwitch-ClientA` | `192.168.20.0/24` (Netz B) |
| `vSwitch-ClientB` | `192.168.30.0/24` (Netz C) |

| VM | Rolle | Ab Modul |
|---|---|---|
| `RTR-LIN` | Linux-Router und Relay, `.1` in jedem Netz | 1 |
| `SRV-WIN-DHCP1` | Windows-DHCP-Server, `192.168.10.11` | 2 |
| `SRV-WIN-DC1` | Domänencontroller, `192.168.10.10` | 6 |
| `SRV-WIN-DHCP2` | Failover-Partner, `192.168.10.12` | 7 |
| `SRV-LIN-KEA` | Kea-Server, `192.168.10.21` | 8 |
| `CLI-WIN-A`, `CLI-LIN-B` | Clients | 1 |

Checkpoints: `M<Nr>-Anfang` je Modul und `BASIS`.

## Module

| Nr. | Modul | Zeit | Prüfstand |
|---|---|---|---|
| 01 | [Grundlagen, Lease-Ablauf und Laboraufbau](01-grundlagen-lease-ablauf-und-laboraufbau/) | 6 h | Linux-Teile real |
| 02 | [Windows-DHCP-Server, Scopes und Basisoptionen](02-windows-dhcp-server-scopes-und-basisoptionen/) | 7,5 h | Quelle geprüft |
| 03 | [Leases, Reservierungen und Ausschlüsse](03-leases-reservierungen-und-ausschluesse/) | 6 h | Quelle geprüft |
| 04 | [Optionen, Klassen, Policies und MAC-Filter](04-optionen-klassen-policies-und-mac-filter/) | 7,5 h | Quelle teilweise |
| 05 | [Mehrere Subnetze und DHCP-Relay](05-mehrere-subnetze-und-dhcp-relay/) | 7,5 h | Relay real |
| 06 | [DHCP in Active Directory: Autorisierung und DDNS](06-dhcp-in-active-directory-autorisierung-und-ddns/) | 7,5 h | Quelle geprüft |
| 07 | [Hochverfügbarkeit: Failover und Split-Scope](07-hochverfuegbarkeit-failover-und-split-scope/) | 6 h | Quelle geprüft |
| 08 | [DHCP unter Linux mit ISC Kea](08-dhcp-unter-linux-mit-isc-kea/) | 6 h | Linux real |
| 09 | [DHCPv6 und IPv6-Adressvergabe](09-dhcpv6-und-ipv6-adressvergabe/) | 6 h | nur Syntax |
| 10 | [Betrieb, Überwachung, Sicherung, Migration](10-betrieb-ueberwachung-sicherung-migration-dokumentation/) | 6 h | Kea-Teil real |
| 11 | [Sicherheit: Rogue DHCP und Härtung](11-sicherheit-rogue-dhcp-und-haertung/) | 6 h | teilweise real |
| 12 | [Fehlersuche und Abschlussprojekt](12-fehlersuche-und-abschlussprojekt/) | 9 h | Linux-Fehlerbilder real |

## Aufbau eines Moduls

Ordner `NN-kurzname/` mit `README.md`, der Übung `NN.1-….md`, den zugehörigen Skripten (`.ps1` mit `-WhatIf`, UTF-8 mit BOM; `.sh` mit `bash -n` geprüft) und `beispiele/` mit echten Ausgaben aus dem Testlauf.

## Sicherheitshinweise

- Alles nur im isolierten Labor (private Switches). Der Rogue-Test in Modul 11 gehört **nie** in ein Netz mit fremden Geräten.
- Kennwörter und gemeinsame Geheimnisse werden nie in Dateien geschrieben; Skripte fragen sie interaktiv ab.
- Domäne `corp.example.com` und alle Adressen sind Beispielwerte nach RFC 2606 bzw. RFC 1918 / RFC 4193.

## Lizenz

Code und Konfigurationen: MIT ([`LICENSE`](LICENSE)). Texte und Dokumentation: CC BY 4.0 ([`LICENSE-DOCS.md`](LICENSE-DOCS.md)).
