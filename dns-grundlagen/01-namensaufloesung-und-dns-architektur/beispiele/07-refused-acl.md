# REFUSED ACL

Beispielausgabe zu Modul 01 (`01-namensaufloesung-und-dns-architektur`). Der Inhalt des Blocks ist unverändert.

```text
; Mitschnitt aus einer Testumgebung (Ubuntu 24.04, BIND 9.18.39), nicht aus dem Labor der Uebung.
; Befehl: dig @192.168.50.11 -b 10.77.0.5 branch.example.org SOA +norecurse


; <<>> DiG 9.18.39-0ubuntu0.24.04.9-Ubuntu <<>> @192.168.50.11 -b 10.77.0.5 branch.example.org SOA +norecurse
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: REFUSED, id: 28025
;; flags: qr; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 34b1a9aab4cb2be1010000006af4856c7ba550344fdcd99d (good)
; EDE: 18 (Prohibited)
;; QUESTION SECTION:
;branch.example.org.		IN	SOA

;; Query time: 4 msec
;; SERVER: 192.168.50.11#53(192.168.50.11) (UDP)
;; WHEN: Wed Nov 11 16:10:36 CET 2026
;; MSG SIZE  rcvd: 81
```
