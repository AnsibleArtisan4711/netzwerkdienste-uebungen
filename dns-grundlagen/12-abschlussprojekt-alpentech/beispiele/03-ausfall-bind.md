# Ausfall des BIND-Servers

Zu Modul 12: [12-abschlussprojekt-alpentech](../12.1-abschlussprojekt-alpentech.md). Dort steht die ausführliche Anleitung.

## Ziel

Ausfall von SRV-LIN-BIND simulieren und zeigen, dass der Windows-Server allein weiter antwortet.

## Voraussetzungen

- Beide Server sind eingerichtet, SRV-WIN-DNS ist wieder gestartet.

## Schritte

1. Beende BIND auf SRV-LIN-BIND:

   ```bash
   sudo rndc stop
   ```

   Mit systemd: `sudo systemctl stop named` (Dienstname je nach Distribution `named` oder `bind9`).
2. Prüfe, dass der Server nicht antwortet:

   ```bash
   dig +time=2 +tries=1 @192.168.50.11 git.dev.alpentech.internal A +short
   ```

3. Führe die Abnahme für den Windows-Server aus:

   ```bash
   SRC=192.168.50.100 bash 12.1-abnahme-pruefen.sh 192.168.50.10
   ```

4. Starte BIND wieder.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# Ausfallsimulation 2: SRV-LIN-BIND beenden
$ sudo rndc stop      (auf dem Linux-Server; mit systemd: sudo systemctl stop named)
$ dig +time=2 +tries=1 @192.168.50.11 git.dev.alpentech.internal A +short
;; communications error to 192.168.50.11#53: connection refused


$ SRC=192.168.50.100 bash 12.1-abnahme-pruefen.sh 192.168.50.10
== Server 192.168.50.10
INFO    Seriennummer hq.alpentech.internal auf 192.168.50.10: 2026111201
INFO    Seriennummer dev.alpentech.internal auf 192.168.50.10: 2026111201

Bestanden: 38   Fehler: 0
Ergebnis: alles in Ordnung
```

## So liest du die Ausgabe

- `connection refused` vom beendeten Server.
- Der Windows-Server besteht alle 38 Prüfungen. Er hat auch `dev.alpentech.internal` als Sekundär.
- Damit funktioniert die Auflösung auch beim Ausfall **jedes** der beiden Server.

## Selbst ausprobieren

Stoppe beide Server nacheinander und notiere, ab wann Clients Fehler sehen (Zeitwerte aus dem Windows-Client-Test).
