# 11 Sicherheit: Rogue DHCP und Härtung

Übung **11.1**: Rogue-DHCP-Server im Labor nachbauen und erkennen, DHCP Guard auf dem virtuellen Switch, Härtung von Windows-DHCP und Kea. Geschätzte Zeit: 6 Stunden (Lehrplan: 8 UE).

> Teilweise getestet (Erkennungsskript, Kea-Konfiguration, Linux-Prüfung real; Hyper-V-Verhalten und Windows nicht ausgeführt). **Nur im isolierten Labor durchführen.**

| Datei | Zweck |
|---|---|
| `11.1-sicherheit-rogue-dhcp-und-haertung.md` | Die Übung |
| `11.1-rogue-kea.conf` | Konfiguration des Rogue-Servers (Labor) |
| `11.1-rogue-erkennen.sh` | Erkennung über Server-ID im Mitschnitt |
| `11.1-dhcp-guard.ps1` | DHCP Guard ein/aus |
| `11.1-windows-haertung-pruefen.ps1` | Nur-Lese-Prüfung Windows |
| `11.1-linux-haertung-pruefen.sh` | Nur-Lese-Prüfung Kea |
