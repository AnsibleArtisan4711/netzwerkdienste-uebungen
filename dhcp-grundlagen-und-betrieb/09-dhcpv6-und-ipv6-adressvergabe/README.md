# 09 DHCPv6 und IPv6-Adressvergabe

Übung **09.1**: SLAAC, stateless und stateful DHCPv6, Router Advertisement mit radvd, DHCPv6 unter Windows und Kea, Relay, Mitschnitt. Geschätzte Zeit: 6 Stunden (Lehrplan: 8 UE).

> Nur Syntax geprüft (`kea-dhcp6 -t`, `radvd -c`, PowerShell-Parser); IPv6-Betrieb in der Testumgebung nicht möglich. Siehe Warnhinweis in der Übung.

| Datei | Zweck |
|---|---|
| `09.1-dhcpv6-und-ipv6-adressvergabe.md` | Die Übung |
| `09.1-radvd.conf` | Router Advertisement für Netz B |
| `09.1-dhcpv6-scope-netz-b.ps1` | Windows-DHCPv6-Scope |
| `09.1-kea-dhcp6.conf` | Kea DHCPv6 für Netz C |
| `09.1-isc-dhcp-relay6.default` | Relay für DHCPv6 (nicht getestet) |
