# 11 Fehlersuche und Monitoring

Übung **11.1**: Abfragewerkzeuge (`dig`, `nslookup`, `Resolve-DnsName`), Logging unter Windows und BIND (`logging`-Block, `rndc querylog`), Paketmitschnitt mit `tcpdump` und drei Störungsszenarien (TCP 53 gesperrt, Seriennummer nicht erhöht, `REFUSED`). Geschätzte Zeit: 7 bis 9 Stunden (Lehrplan: 10 UE).

> BIND-Teil und Szenarien A bis C real getestet (BIND 9.18.39; `SRV-WIN-DNS` durch eine zweite BIND-Instanz ersetzt, TCP-Sperre mit `iptables`). **Der Windows-Teil wurde nicht ausgeführt**; die Skripte sind auf Syntax und Parameternamen geprüft. Weiterleitungsschleifen und `journalctl` wurden nicht getestet.

| Datei | Zweck |
|---|---|
| `11.1-fehlersuche-und-monitoring.md` | Die Übung |
| `11.1-named.conf.logging` | `logging`-Block mit Kanälen und Kategorien |
| `11.1-serial-vergleichen.sh` | Vergleicht SOA-Seriennummern auf mehreren Servern (nur lesend) |
| `11.1-bind-diagnose.sh` | Sammelt Status, Zonenstatus, Antwort und letzte Logzeilen (nur lesend) |
| `11.1-windows-abfragen.ps1` | `Resolve-DnsName`-Abfragen und Ereignisprotokoll (nur lesend) |
| `11.1-windows-debuglog.ps1` | Debug-Protokollierung ein/aus (`-Starten`, `-Beenden`, `-WhatIf`) |
| `beispiele/` | Echte Mitschnitte: `dig`, Query-Log, `tcpdump`, Szenarien A bis C |
