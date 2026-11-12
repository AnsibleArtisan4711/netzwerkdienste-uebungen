# Korrekturen und Anmerkungen zum Lehrplan P71

Beim Ausarbeiten der Übungen sind Punkte aufgefallen, die im Lehrplan `P71 – Lehrplan DHCP, Grundlagen und Betrieb` geändert oder überprüft werden sollten. Der Lehrplan selbst wurde **nicht** verändert.

| Nr. | Modul | Stelle im Lehrplan | Befund | Vorschlag |
|---|---|---|---|---|
| 1 | 10 | Audit-Log auswerten mit `Get-DhcpServerAuditLog` | Das Cmdlet liefert nur die **Einstellungen** (Pfad, Aktivierung, Größe), nicht den Inhalt. Der Inhalt steht in den Dateien im konfigurierten Pfad. | Formulierung auf „Audit-Log-Datei lesen; Einstellungen mit `Get-DhcpServerAuditLog`“ ändern. |
| 2 | 4 | `ipconfig /setclassid` | Der Befehl stammt aus dem Lehrplan und ist nicht bestätigt. | Vor Übernahme mit `ipconfig /?` auf dem Zielsystem prüfen. |
| 3 | 4 | Policy und Reservierung | Reihenfolge und Wirkung der Policy-Lease-Dauer bei Reservierung sind nicht bestätigt. | Als Beobachtungsaufgabe formulieren oder Reservierung ausnehmen (so umgesetzt). |
| 4 | 5 | Relay mit mehreren Servern | Aussage zum Verhalten des Windows-Servers ohne Scope fehlt; Kea schweigt nachweislich. | Als Prüfauftrag ergänzen. |
| 5 | 9 | DHCPv6 | In der Testumgebung nicht prüfbar (kein IPv6-Kernel). | Hinweis auf Prüfstand ergänzen. |
| 6 | 7 | Zeitangaben Failover | Zustandsnamen nicht geprüft. | Beim ersten Durchlauf mit echten Ausgaben ergänzen. |
| 7 | alle | Zeitplan | 108 UE entsprechen bei 45 Minuten 81 Stunden; die Übungen sind darauf ausgelegt, nicht auf mehr. | Keine Änderung nötig; Abschlussprojekt kann länger dauern. |

Weitere Hinweise zu nicht bestätigten Aussagen: `befehle-nicht-bestaetigt.md`.
