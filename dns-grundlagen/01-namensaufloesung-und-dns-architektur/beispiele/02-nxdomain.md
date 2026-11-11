# NXDOMAIN

Beispielausgabe zu Modul 01 (`01-namensaufloesung-und-dns-architektur`). Der Inhalt des Blocks ist unverändert.

```text
; Mitschnitt aus einer Testumgebung (Ubuntu 24.04, BIND 9.18.39), nicht aus dem Labor der Uebung.
; Befehl: dig @192.168.50.11 gibtsnicht.branch.example.org A +norecurse


; <<>> DiG 9.18.39-0ubuntu0.24.04.9-Ubuntu <<>> @192.168.50.11 gibtsnicht.branch.example.org A +norecurse
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 57420
;; flags: qr aa ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 7440c63e624d63be010000006af4856cdb086f9304c1ed27 (good)
;; QUESTION SECTION:
;gibtsnicht.branch.example.org.	IN	A

;; AUTHORITY SECTION:
branch.example.org.	3600	IN	SOA	linserver.branch.example.org. hostmaster.branch.example.org. 2026110801 900 300 604800 3600

;; Query time: 0 msec
;; SERVER: 192.168.50.11#53(192.168.50.11) (UDP)
;; WHEN: Wed Nov 11 16:10:36 CET 2026
;; MSG SIZE  rcvd: 143
```
