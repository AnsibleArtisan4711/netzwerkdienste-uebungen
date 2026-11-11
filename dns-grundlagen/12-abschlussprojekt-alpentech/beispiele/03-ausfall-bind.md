# Ausfall des BIND-Servers

Beispielausgabe zu Modul 12 (`12-abschlussprojekt-alpentech`). Der Inhalt des Blocks ist unverändert.

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
