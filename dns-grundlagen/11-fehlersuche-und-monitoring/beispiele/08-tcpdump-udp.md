# tcpdump: UDP

Zu Modul 11: [11-fehlersuche-und-monitoring](../11.1-fehlersuche-und-monitoring.md). Dort steht die ausführliche Anleitung.

## Ziel

Eine einfache DNS-Abfrage im Netzwerkmitschnitt (`tcpdump`) sehen.

## Voraussetzungen

- `tcpdump` ist installiert, du hast Administratorrechte.
- Im Testlabor liefen beide Server auf einem Rechner, daher `-i lo`. Im echten Labor nimmst du `-i any` oder die Schnittstelle des Servers.

## Schritte

1. Starte den Mitschnitt (in einem Fenster):

   ```bash
   sudo tcpdump -i any port 53 -nn
   ```

2. Sende in einem zweiten Fenster zwei Abfragen von `192.168.50.100`, eine für einen vorhandenen und eine für einen nicht vorhandenen Namen:

   ```bash
   dig @192.168.50.11 www.branch.example.org A
   dig @192.168.50.11 nichtda.branch.example.org A
   ```

3. Beende den Mitschnitt mit `Strg+C`.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
$ sudo tcpdump -i any port 53 -nn   (hier: -i lo, weil im Testlabor beide Server auf einem Rechner laufen)
$ (zwei Abfragen von 192.168.50.100: ein vorhandener und ein nicht vorhandener Name)
IP 192.168.50.100.59187 > 192.168.50.11.53: 27809+ [1au] A? www.branch.example.org. (63)
IP 192.168.50.11.53 > 192.168.50.100.59187: 27809* 2/0/1 CNAME web.branch.example.org., A 192.168.50.40 (113)
IP 192.168.50.100.54180 > 192.168.50.11.53: 49955+ [1au] A? nichtda.branch.example.org. (67)
```

## So liest du die Ausgabe

- `27809+ [1au] A? www.branch.example.org.`: Abfrage-ID, `+` = Rekursion gewünscht, `[1au]` = ein EDNS-Eintrag, `A?` = Frage nach dem Typ A.
- Die Antwort trägt dieselbe ID und ein `*` für autoritativ. `2/0/1` heißt: 2 Antworten, 0 Autorität, 1 Zusatz.
- Mit `-nn` löst `tcpdump` weder Namen noch Ports auf. Wichtig, damit der Mitschnitt selbst kein DNS verursacht.

## Selbst ausprobieren

Filtere auf eine Quelladresse: `sudo tcpdump -i any host 192.168.50.100 and port 53 -nn`.
