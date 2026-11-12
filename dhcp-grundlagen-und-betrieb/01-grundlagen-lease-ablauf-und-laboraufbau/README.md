# 01 Grundlagen von DHCP, Lease-Ablauf und Laboraufbau

Übung **01.1**: DORA und Lease-Zeiten verstehen, Hyper-V-Labor mit drei privaten Switches und dem Linux-Router `RTR-LIN` aufbauen, einen Ablauf im Mitschnitt lesen. Geschätzte Zeit: 6 Stunden (Lehrplan: 8 UE).

> Linux-Teile in einer Testumgebung ausgeführt, Hyper-V und Windows nicht (siehe Warnhinweis in der Übung).

| Datei | Zweck |
|---|---|
| `01.1-grundlagen-lease-ablauf-und-laboraufbau.md` | Die Übung |
| `01.1-switches-anlegen.ps1` | Die drei privaten Hyper-V-Switches |
| `01.1-rtr-lin-netplan.yaml` | Netplan für `RTR-LIN` (Schnittstellen über MAC benannt) |
| `01.1-rtr-lin-sysctl.conf` | IPv4-Weiterleitung |
| `01.1-mitschnitt.sh` | `tcpdump`-Hilfsskript |
| `beispiele/01-dora-mitschnitt.md` | Echter DORA-Mitschnitt (Client-Seite) |
