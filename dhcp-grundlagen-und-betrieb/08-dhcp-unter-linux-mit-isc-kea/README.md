# 08 DHCP unter Linux mit ISC Kea

Übung **08.1**: Kea DHCPv4 installieren, konfigurieren, prüfen, hinter dem Relay betreiben, Reservierung, typische Fehler. Geschätzte Zeit: 6 Stunden (Lehrplan: 8 UE).

> Der Linux-Teil wurde mit Kea 2.4.1 (Ubuntu 24.04) real getestet, ohne `systemctl` und ohne Hyper-V. Siehe Warnhinweis in der Übung.

| Datei | Zweck |
|---|---|
| `08.1-dhcp-unter-linux-mit-isc-kea.md` | Die Übung |
| `08.1-kea-dhcp4.conf` | Grundkonfiguration (mit `kea-dhcp4 -t` geprüft) |
| `08.1-kea-dhcp4-reservierung.conf` | Mit Reservierung (MAC ersetzen) |
| `08.1-relay-auf-kea.default` | Relay-Konfiguration für `RTR-LIN` |
| `08.1-kea-pruefen.sh` | Sammelprüfung |
| `beispiele/08-kea-testlauf.md` | Echte Logs aus dem Testlauf |
