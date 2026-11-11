# Ausfall des Windows-Servers

Zu Modul 12: [12-abschlussprojekt-alpentech](../12.1-abschlussprojekt-alpentech.md). Dort steht die ausführliche Anleitung.

## Ziel

Ausfall von SRV-WIN-DNS simulieren und zeigen, dass BIND allein weiter antwortet.

## Voraussetzungen

- Beide Server sind eingerichtet, die Abnahme aus dem ersten Beispiel war erfolgreich.
- Im Test wurde die Ersatzinstanz auf `192.168.50.10` mit `rndcb stop` beendet. Unter Windows nimmst du `Stop-Service DNS` (PowerShell, als Administrator).

## Schritte

1. Beende den Windows-DNS-Dienst:

   ```powershell
   Stop-Service DNS
   ```

2. Prüfe, dass der Server nicht mehr antwortet:

   ```bash
   dig +time=2 +tries=1 @192.168.50.10 fs01.hq.alpentech.internal A +short
   ```

3. Führe die Abnahme für beide Server aus:

   ```bash
   SRC=192.168.50.100 bash 12.1-abnahme-pruefen.sh 192.168.50.11
   SRC=192.168.50.100 bash 12.1-abnahme-pruefen.sh 192.168.50.10
   ```

4. Prüfe die Client-Sicht über BIND:

   ```bash
   dig @192.168.50.11 -x 192.168.50.53 +short
   dig @192.168.50.11 intranet.hq.alpentech.internal A +short
   dig @192.168.50.11 -x fd00:50::61 +short
   ```

5. Starte den Dienst wieder: `Start-Service DNS`.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus. Der Windows-Server wurde im Test durch eine zweite BIND-Instanz ersetzt. **Echte Windows-Ausgaben können abweichen.**

```text
# Ausfallsimulation 1: SRV-WIN-DNS (im Testlabor: Ersatzinstanz auf 192.168.50.10) beenden
$ rndcb stop      (unter Windows: Stop-Service DNS)
$ dig +time=2 +tries=1 @192.168.50.10 fs01.hq.alpentech.internal A +short
;; communications error to 192.168.50.10#53: connection refused


$ SRC=192.168.50.100 bash 12.1-abnahme-pruefen.sh 192.168.50.11
== Server 192.168.50.11
INFO    Seriennummer hq.alpentech.internal auf 192.168.50.11: 2026111201
INFO    Seriennummer dev.alpentech.internal auf 192.168.50.11: 2026111201

Bestanden: 38   Fehler: 0
Ergebnis: alles in Ordnung

$ SRC=192.168.50.100 bash 12.1-abnahme-pruefen.sh 192.168.50.10   (zum Vergleich: der gestoppte Server)

Bestanden: 0   Fehler: 38
Ergebnis: 38 Pruefung(en) fehlgeschlagen

# Client-Sicht: Der BIND-Server antwortet allein, auch fuer Reverse-Abfragen
$ dig @192.168.50.11 -x 192.168.50.53 +short
erp.hq.alpentech.internal.
$ dig @192.168.50.11 intranet.hq.alpentech.internal A +short
fs01.hq.alpentech.internal.
192.168.50.51
$ dig @192.168.50.11 -x fd00:50::61 +short
git.dev.alpentech.internal.
```

## So liest du die Ausgabe

- Der beendete Server meldet `connection refused`. Das Skript zählt dort 38 Fehler.
- Der BIND-Server besteht alle 38 Prüfungen: Er hat die Zonen als Sekundär kopiert und antwortet allein, auch für Reverse-Abfragen.
- Das ist der Beleg für Redundanz. Voraussetzung: Clients haben beide Server als DNS-Server eingetragen.

## Selbst ausprobieren

Prüfe mit `12.1-windows-client-ausfalltest.ps1`, wie ein Windows-Client mit dem Ausfall umgeht.
