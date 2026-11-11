# Corp-Einträge und PTR

Beispielausgabe zu Modul 05 (`05-resource-records-und-reverse-zonen`). Der Inhalt des Blocks ist unverändert.

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
