# dig: norecurse und Header

Beispielausgabe zu Modul 11 (`11-fehlersuche-und-monitoring`). Der Inhalt des Blocks ist unverändert.

```text
$ dig @192.168.50.10 files.corp.example.com A +norecurse

; <<>> DiG 9.18.39-0ubuntu0.24.04.9-Ubuntu <<>> @192.168.50.10 files.corp.example.com A +norecurse
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 39301
;; flags: qr aa ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: b7a4d2535a4221ff010000006af494e966b4db5400e286c4 (good)
;; QUESTION SECTION:
;files.corp.example.com.		IN	A

;; ANSWER SECTION:
files.corp.example.com.	3600	IN	A	192.168.50.20

;; AUTHORITY SECTION:
corp.example.com.	3600	IN	NS	linserver.branch.example.org.
corp.example.com.	3600	IN	NS	winserver.corp.example.com.

;; ADDITIONAL SECTION:
winserver.corp.example.com. 3600 IN	A	192.168.50.10
winserver.corp.example.com. 3600 IN	AAAA	fd00:50::10

;; Query time: 0 msec
;; SERVER: 192.168.50.10#53(192.168.50.10) (UDP)
;; WHEN: Wed Nov 11 17:16:41 CET 2026
;; MSG SIZE  rcvd: 205
```
