# tcpdump: NXDOMAIN

Zu Modul 11: [11-fehlersuche-und-monitoring](../11.1-fehlersuche-und-monitoring.md). Dort steht die ausführliche Anleitung.

## Ziel

Eine verneinte Abfrage im ausführlichen Mitschnitt (`-vv`) lesen.

## Voraussetzungen

- Wie im vorigen Beispiel. Im Testlabor wurde auf der Loopback-Schnittstelle mitgeschnitten (`-i lo`).

## Schritte

1. Starte den Mitschnitt mit mehr Details:

   ```bash
   sudo tcpdump -i any port 53 -nn -vv
   ```

2. Frage in einem zweiten Fenster einen nicht vorhandenen Namen:

   ```bash
   dig @192.168.50.11 nichtda.branch.example.org A
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
$ sudo tcpdump -i any port 53 -nn -vv   (hier: -i lo)
$ dig @192.168.50.11 nichtda.branch.example.org A   (nicht vorhandener Name)
IP (tos 0x0, ttl 64, id 372, offset 0, flags [none], proto UDP (17), length 95)
    192.168.50.100.37284 > 192.168.50.11.53: [bad udp cksum 0xe61c -> 0x18e1!] 28892+ [1au] A? nichtda.branch.example.org. ar: . OPT UDPsize=1232 [COOKIE f8cd2b330ec7071e
IP (tos 0x0, ttl 64, id 9234, offset 0, flags [none], proto UDP (17), length 168)
    192.168.50.11.53 > 192.168.50.100.37284: [bad udp cksum 0xe665 -> 0x97e9!] 28892 NXDomain* q: A? nichtda.branch.example.org. 0/1/1 ns: branch.example.org. SOA linserv
2 packets captured
4 packets received by filter
0 packets dropped by kernel
# Hinweis: "bad udp cksum" ist ein Artefakt des Mitschnitts auf der Loopback-Schnittstelle (Pruefsummen-Offload), kein Fehler der Antwort.
```

## So liest du die Ausgabe

- `NXDomain*`: Die Antwort verneint den Namen, `*` heißt autoritativ.
- `0/1/1` im Antwortpaket: keine Antwortdaten, 1 Autorität (der SOA), 1 Zusatz (EDNS).
- `bad udp cksum` ist ein **Artefakt** des Mitschnitts auf der Loopback-Schnittstelle (Prüfsummen-Offload) und kein Fehler der Antwort.
- `2 packets captured` zählt die mitgeschnittenen Pakete: hier Frage und Antwort.

## Selbst ausprobieren

Vergleiche die Ausgabe mit `-vv` und ohne `-vv`: Was kommt hinzu?
