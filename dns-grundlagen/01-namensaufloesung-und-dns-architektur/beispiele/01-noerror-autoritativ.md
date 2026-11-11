# NOERROR autoritativ

Beispielausgabe zu Modul 01 (`01-namensaufloesung-und-dns-architektur`). Der Inhalt des Blocks ist unverändert.

```text
; Mitschnitt aus einer Testumgebung (Ubuntu 24.04, BIND 9.18.39), nicht aus dem Labor der Uebung.
; Befehl: dig @192.168.50.11 branch.example.org SOA +norecurse


; <<>> DiG 9.18.39-0ubuntu0.24.04.9-Ubuntu <<>> @192.168.50.11 branch.example.org SOA +norecurse
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 31999
;; flags: qr aa ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 054e929ee01e1329010000006af4856c6cbdadea19aecb25 (good)
;; QUESTION SECTION:
;branch.example.org.		IN	SOA

;; ANSWER SECTION:
branch.example.org.	3600	IN	SOA	linserver.branch.example.org. hostmaster.branch.example.org. 2026110801 900 300 604800 3600

;; AUTHORITY SECTION:
branch.example.org.	3600	IN	NS	linserver.branch.example.org.

;; ADDITIONAL SECTION:
linserver.branch.example.org. 3600 IN	A	192.168.50.11

;; Query time: 0 msec
;; SERVER: 192.168.50.11#53(192.168.50.11) (UDP)
;; WHEN: Wed Nov 11 16:10:36 CET 2026
;; MSG SIZE  rcvd: 162
```
