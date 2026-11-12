# Befehle und Aussagen, die nicht bestätigt sind

Diese Liste sammelt, was in den Übungen **nicht** durch einen Lauf oder durch Microsoft Learn belegt ist. Sie dient als Prüfliste für den ersten Durchlauf im Labor: Trage Befund und Datum ein und entferne danach den Hinweis in der Übung.

Legende: **Q** = gegen Quelle (Microsoft Learn) geprüft, nicht ausgeführt; **L** = real in der Linux-Testumgebung ausgeführt; **–** = weder noch.

## Grundsätzlich

- **Kein Windows-Befehl wurde ausgeführt.** Alle PowerShell-Skripte wurden nur auf Syntax geprüft (PowerShell 7.4.6 Parser); die Cmdlet-Parameter sind teils gegen Microsoft Learn geprüft (siehe Tabelle).
- **IPv6 wurde nirgends im Betrieb getestet** (der Kernel der Testumgebung hatte keinen IPv6-Stack). Geprüft wurden nur `kea-dhcp6 -t` und `radvd -c`.
- Hyper-V wurde nicht verwendet; die Netze wurden mit Linux-Namespaces nachgebildet.

## Tabelle

| Modul | Aussage oder Befehl | Status | Was im Labor zu prüfen ist |
|---|---|---|---|
| 1 | Windows-Verhalten ohne DHCP-Antwort (APIPA-Dauer, Wiederholungen) | – | Beobachten, notieren |
| 1 | Debian 12 als `RTR-LIN` (Netplan statt `interfaces`) | – | Ubuntu 24.04 ist getestet |
| 1 | `bad udp cksum` unter Hyper-V | L (nur Linux) | Prüfen, ob auch dort Offload-Artefakt |
| 2 | Verhalten eines nicht autorisierten Servers in Arbeitsgruppe | – | Teil 1 der Übung |
| 2 | Standardpfad von Datenbank und Audit-Log | – | `Get-DhcpServerDatabase`, `Get-DhcpServerAuditLog` |
| 2 | Internetbedarf bei `Install-WindowsFeature` | – | Prüfen |
| 3 | Konflikterkennung (ICMP vor Vergabe), Property-Namen der Statistik | Q (Wertebereich 0–5, Standard 0) | `Get-Member`, Mitschnitt |
| 3 | Reservierung außerhalb des Scope-Bereichs | – | Nicht verwendet |
| 4 | `Add-DhcpServerv4Filter`-Syntax und MAC-Format | – | `Get-Help Add-DhcpServerv4Filter` |
| 4 | `ipconfig /setclassid` | – | `ipconfig /?` |
| 4 | Vorrang von Policy gegenüber Reservierung, Policy-Lease auf Reservierung | – | Reservierung temporär entfernt (Übung) |
| 4 | Auswertung von Option 42 und Vendor-Optionen durch Windows 11 | – | Mitschnitt |
| 5 | Superscope-Syntax | – | Nur Nachschlagen |
| 5 | Relay-Option 82 (`-a`) | – | `dhcrelay -h` |
| 5 | Windows-Server ohne passenden Scope bei Relay-Fanout | – | Teil „zwei Server“, Modul 12 |
| 6 | Option 81 (FQDN) von Windows 11 | – | Mitschnitt |
| 6 | `Add-DnsServerPrimaryZone`-Parameter | – | `Get-Help` |
| 6 | Rechte des DNS-Dienstkontos | Q (`Set-DhcpServerDnsCredential`) | Test in Teil 4 |
| 6 | Verhalten des nicht autorisierten Servers in der Domäne | – | Beobachten |
| 7 | Failover-Zustandsnamen, Zeitverhalten, Portnummer | – | Beobachten |
| 7 | Replikation von Server-Optionen | – | `Get-DhcpServerv4OptionValue` |
| 7 | `Add-DhcpServerv4FailoverScope` | – | `Get-Help` |
| 7 | Verhalten von `Remove-DhcpServerv4Failover` beim Partner | – | Prüfen |
| 8 | Start per `systemctl` | – | In der Testumgebung nicht möglich |
| 8 | Reservierung im Pool bei Kea | – | Nicht verwendet |
| 9 | Alles zu DHCPv6 im Betrieb (RA, Solicit, Relay6) | – | Kompletter Test im Labor |
| 9 | `Add-DhcpServerv6ExclusionRange`, `Add-DhcpServerv6Reservation` | – | `Get-Help` |
| 9 | Windows-11-Verhalten bei M/O-Flag | – | Mitschnitt |
| 10 | `Backup-DhcpServer` / `Restore-DhcpServer` | – | Nicht verwendet (Export/Import stattdessen) |
| 10 | Name des Ereignisprotokolls, Muster der Audit-Logdateien | – | Ereignisanzeige, Dateisystem |
| 10 | Spalten `InUse`/`Free` der Statistik | Q (`PercentageInUse` im Beispiel) | `Format-List *` |
| 11 | DHCP Guard wirkt im Labor wie dokumentiert; Wirkung auf Relay-VM | Q (`-DhcpGuard`) | Teil 2 der Übung |
| 11 | Eigenschaft `DhcpGuard` in `Get-VMNetworkAdapter` | – | Ausgabe prüfen |
| 12 | Windows-Fehlerbilder D, F, G | – | Teil 2 der Übung |

## Bereits bestätigt (Quelle oder Lauf)

| Aussage | Beleg |
|---|---|
| `Set-DhcpServerv4DnsSetting`, `Set-DhcpServerSetting` (-ConflictDetectionAttempts 0–5), `Add-DhcpServerv4Failover`, `Add-DhcpServerv4Policy`, `Set-DhcpServerv4FilterList`, `Add-DhcpServerv4Class`, `Export-DhcpServer`, `Import-DhcpServer`, `Add-DhcpServerv6Scope`, `Set-DhcpServerv6OptionValue`, `Set-VMNetworkAdapter -DhcpGuard` | Microsoft Learn |
| Relay leitet an alle Server; nur der mit passendem Subnetz antwortet (Kea) | Lauf (L) |
| Kea schweigt bei fehlendem Subnetz (`DHCP4_PACKET_NAK_0001`) | Lauf (L) |
| `kea-dhcp4 -t` meldet nicht vorhandene Schnittstelle | Lauf (L) |
| `600 root:root` ist für `_kea` unlesbar | Lauf (L) |
| `bad udp cksum` bei lokal erzeugten Paketen | Lauf (L) |
