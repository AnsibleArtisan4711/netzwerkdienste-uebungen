# 12 Abschlussprojekt AlpenTech

Übung **12.1**: Hybride DNS-Infrastruktur der fiktiven AlpenTech GmbH. Spezifikation, Windows- und BIND-Seite mit gegenseitigen Sekundärzonen, Reverse-Zonen (IPv4 und IPv6), Abnahmetest, Ausfallsimulation je Server, Betriebsdokumentation. Geschätzte Zeit: 5 bis 7 Stunden (Lehrplan: 8 UE).

> BIND-Teil real getestet (BIND 9.18.39; `SRV-WIN-DNS` durch eine zweite BIND-Instanz ersetzt). **Der Windows-Teil wurde nicht ausgeführt**; die Skripte sind auf Syntax und Parameternamen geprüft.

| Datei | Zweck |
|---|---|
| `12.1-abschlussprojekt-alpentech.md` | Die Übung |
| `12.1-vorlage-anforderungsspezifikation.md` | Vorlage für Teil 1 |
| `12.1-vorlage-abnahmeprotokoll.md` | Vorlage für die Abnahme |
| `12.1-vorlage-betriebsdokumentation.md` | Vorlage für Teil 6 |
| `12.1-db.hq.alpentech.internal` | Vergleichsdatei der Windows-Zone `hq` |
| `12.1-db.dev.alpentech.internal` | Zonendatei der BIND-Zone `dev` |
| `12.1-ptr-ergaenzung.50.168.192.in-addr.arpa` | PTR-Ergänzung IPv4 (auf Windows anlegen) |
| `12.1-ptr-ergaenzung.ip6.arpa` | PTR-Ergänzung IPv6 (auf Windows anlegen) |
| `12.1-named.conf.local-ergaenzung` | Zonenblöcke für `named.conf.local` |
| `12.1-abnahme-pruefen.sh` | Abnahmetest (nur lesend), optional Servernamen als Argumente |
| `12.1-windows-alpentech-einrichten.ps1` | Windows-Seite einrichten (`-WhatIf`) |
| `12.1-windows-client-ausfalltest.ps1` | Client: zweiter DNS-Server, Prüfung, Bereinigung (`-Beginn`, `-Pruefen`, `-Ende`) |
| `beispiele/` | Echte Mitschnitte: Abnahme, Ausfälle, Expire, Transferbeschränkung |
