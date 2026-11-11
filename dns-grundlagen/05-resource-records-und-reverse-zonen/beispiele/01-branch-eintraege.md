# Branch-Einträge

Zu Modul 05: [05-resource-records-und-reverse-zonen](../05.1-resource-records-und-reverse-zonen.md). Dort steht die ausführliche Anleitung.

## Ziel

Die in Modul 5 angelegten Record-Typen der Zone `branch.example.org` mit `dig` gezielt abfragen und lesen.

## Voraussetzungen

- Die Zonendatei `branch.example.org` aus Modul 5 ist auf SRV-LIN-BIND (`192.168.50.11`) geladen.
- `dig` ist installiert.

## Schritte

1. Frage jeden Typ einzeln ab. `+noall +answer +additional` blendet alles außer Antwort und Zusatzteil aus:

   ```bash
   dig @192.168.50.11 linserver.branch.example.org A +noall +answer +additional
   dig @192.168.50.11 linserver.branch.example.org AAAA +noall +answer +additional
   dig @192.168.50.11 www.branch.example.org A +noall +answer +additional
   dig @192.168.50.11 branch.example.org MX +noall +answer +additional
   dig @192.168.50.11 branch.example.org TXT +noall +answer +additional
   dig @192.168.50.11 _ldap._tcp.branch.example.org SRV +noall +answer +additional
   ```

2. Vergleiche jede Ausgabe mit der Zonendatei.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# Echte dig-Ausgaben (BIND 9.18.39). Eintraege der Zone branch.example.org von SRV-LIN-BIND

$ dig @192.168.50.11 linserver.branch.example.org A +noall +answer +additional
linserver.branch.example.org. 3600 IN	A	192.168.50.11

$ dig @192.168.50.11 linserver.branch.example.org AAAA +noall +answer +additional
linserver.branch.example.org. 3600 IN	AAAA	fd00:50::11

$ dig @192.168.50.11 www.branch.example.org A +noall +answer +additional
www.branch.example.org.	3600	IN	CNAME	web.branch.example.org.
web.branch.example.org.	3600	IN	A	192.168.50.40

$ dig @192.168.50.11 branch.example.org MX +noall +answer +additional
branch.example.org.	3600	IN	MX	10 linserver.branch.example.org.
linserver.branch.example.org. 3600 IN	A	192.168.50.11
linserver.branch.example.org. 3600 IN	AAAA	fd00:50::11

$ dig @192.168.50.11 branch.example.org TXT +noall +answer +additional
branch.example.org.	3600	IN	TXT	"v=spf1 mx -all"

$ dig @192.168.50.11 _ldap._tcp.branch.example.org SRV +noall +answer +additional
_ldap._tcp.branch.example.org. 3600 IN	SRV	10 100 389 linserver.branch.example.org.
linserver.branch.example.org. 3600 IN	A	192.168.50.11
linserver.branch.example.org. 3600 IN	AAAA	fd00:50::11
```

## So liest du die Ausgabe

- `A` und `AAAA`: eine IPv4- bzw. IPv6-Adresse für `linserver`.
- `CNAME` (`www` → `web`): Der Resolver bekommt die Kette gleich mit, hier endet sie bei `192.168.50.40`.
- `MX`: `10` ist die Priorität, kleinere Zahl zuerst. Im Zusatzteil stehen die Adressen des Mailservers.
- `TXT` mit `v=spf1 mx -all`: SPF-Eintrag, erlaubt nur den MX-Hosts den Versand.
- `SRV` `10 100 389 …`: Priorität, Gewicht, Port, Ziel. Der Name `_ldap._tcp` folgt dem SRV-Schema `_dienst._protokoll`.

## Selbst ausprobieren

Ändere in einer Kopie der Zone die MX-Priorität und lade neu, dann vergleiche.
