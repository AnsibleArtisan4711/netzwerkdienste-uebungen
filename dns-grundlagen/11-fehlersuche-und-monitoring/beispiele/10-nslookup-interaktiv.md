# nslookup interaktiv

Zu Modul 11: [11-fehlersuche-und-monitoring](../11.1-fehlersuche-und-monitoring.md). Dort steht die ausführliche Anleitung.

## Ziel

`nslookup` im interaktiven Modus benutzen: Server wechseln, Typ setzen, Debug-Ausgabe lesen.

## Voraussetzungen

- `nslookup` ist auf jedem Windows- und vielen Linux-Systemen vorhanden.
- Der Mitschnitt stammt von `nslookup` aus BIND (Linux). Die Windows-Version formatiert die Ausgabe anders (sinngemäß).

## Schritte

1. Starte `nslookup`:

   ```bash
   nslookup
   ```

2. Setze Server und Typ und frage ab (Eingaben im Programm):

   ```text
   server 192.168.50.10
   set type=MX
   branch.example.org
   set debug
   set type=A
   files.corp.example.com
   exit
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# Hinweis: Mitschnitt von nslookup aus BIND (Linux). Die Windows-Version formatiert die Ausgabe anders (sinngemaess).
$ nslookup
Default server: 192.168.50.10
Address: 192.168.50.10#53
Server:		192.168.50.10
Address:	192.168.50.10#53

branch.example.org	mail exchanger = 10 linserver.branch.example.org.
Server:		192.168.50.10
Address:	192.168.50.10#53

------------
    QUESTIONS:
	files.corp.example.com, type = A, class = IN
    ANSWERS:
    ->  files.corp.example.com
	internet address = 192.168.50.20
	ttl = 3600
    AUTHORITY RECORDS:
    ADDITIONAL RECORDS:
------------
Name:	files.corp.example.com
Address: 192.168.50.20
```

## So liest du die Ausgabe

- Zuerst steht der Standardserver. `server …` wechselt den befragten Server.
- `set type=MX` zeigt Mailserver: `mail exchanger = 10 …`.
- `set debug` zeigt Frage, Antwort, Autorität und die `ttl` des Eintrags.
- Aufbau und Wortlaut unterscheiden sich unter Windows. Für die Fehlersuche ist `dig` genauer.

## Selbst ausprobieren

Probiere `set type=PTR` und frage eine Adresse rückwärts ab.
