# Corp-Einträge und PTR

Zu Modul 05: [05-resource-records-und-reverse-zonen](../05.1-resource-records-und-reverse-zonen.md). Dort steht die ausführliche Anleitung.

## Ziel

Die Einträge der Zone `corp.example.com` und die Reverse-Auflösung (PTR) lesen, einschließlich des Falls ohne PTR.

## Voraussetzungen

- Zone `corp.example.com` und die Reverse-Zonen aus Modul 5 sind auf `192.168.50.10` geladen.
- Im Test antwortete eine BIND-Instanz als Stellvertreter für SRV-WIN-DNS. Ein echter Windows-Server liefert dieselben Daten, TTL und Flags können abweichen.

## Schritte

1. Frage die Vorwärtseinträge ab (`+noall +answer` zeigt nur die Antwort):

   ```bash
   dig @192.168.50.10 intranet.corp.example.com A +noall +answer
   dig @192.168.50.10 corp.example.com MX +noall +answer
   dig @192.168.50.10 _sip._tcp.corp.example.com SRV +noall +answer
   ```

2. Frage die Reverse-Einträge mit `-x` ab (`dig` bildet den `in-addr.arpa`- bzw. `ip6.arpa`-Namen selbst):

   ```bash
   dig @192.168.50.10 -x 192.168.50.10 +noall +answer
   dig @192.168.50.10 -x fd00:50::11 +noall +answer
   ```

3. Frage eine Adresse ab, für die es **keinen** PTR gibt, und lies den Status:

   ```bash
   dig @192.168.50.10 -x 192.168.50.25
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus. Der Windows-Server wurde im Test durch eine zweite BIND-Instanz ersetzt. **Echte Windows-Ausgaben können abweichen.**

```text
# Echte dig-Ausgaben (BIND 9.18.39 als Stellvertreter fuer SRV-WIN-DNS, nur Datenabschnitt). Windows liefert dieselben Daten; TTL und Flags koennen abweichen.

$ dig @192.168.50.10 intranet.corp.example.com A +noall +answer
intranet.corp.example.com. 3600	IN	CNAME	files.corp.example.com.
files.corp.example.com.	3600	IN	A	192.168.50.20

$ dig @192.168.50.10 corp.example.com MX +noall +answer
corp.example.com.	3600	IN	MX	10 mail.corp.example.com.

$ dig @192.168.50.10 corp.example.com TXT +noall +answer
corp.example.com.	3600	IN	TXT	"v=spf1 mx -all"

$ dig @192.168.50.10 _sip._tcp.corp.example.com SRV +noall +answer
_sip._tcp.corp.example.com. 3600 IN	SRV	10 100 5060 voip.corp.example.com.

$ dig @192.168.50.10 -x 192.168.50.10 +noall +answer
10.50.168.192.in-addr.arpa. 3600 IN	PTR	winserver.corp.example.com.

$ dig @192.168.50.10 -x fd00:50::11 +noall +answer
1.1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.5.0.0.0.0.d.f.ip6.arpa. 3600 IN PTR linserver.branch.example.org.

$ dig @192.168.50.10 -x 192.168.50.25   (kein PTR angelegt)
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 9381
50.168.192.in-addr.arpa. 3600	IN	SOA	winserver.corp.example.com. hostmaster.corp.example.com. 2026111101 900 300 604800 3600
```

## So liest du die Ausgabe

- `intranet` ist ein `CNAME` auf `files`, die Antwort enthält die ganze Kette.
- Der PTR-Name `10.50.168.192.in-addr.arpa` ist die Adresse **rückwärts** geschrieben. Bei IPv6 ist es jede Hexstelle einzeln, rückwärts, unter `ip6.arpa`.
- Ohne PTR-Eintrag kommt `NXDOMAIN`, und in der Autorität steht der SOA der Reverse-Zone `50.168.192.in-addr.arpa`.

## Selbst ausprobieren

Lege für `192.168.50.25` einen PTR an und wiederhole die letzte Abfrage.
