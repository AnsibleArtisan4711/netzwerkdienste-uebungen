# norecurse und rekursiv im Vergleich

Beispielausgabe zu Modul 11 (`11-fehlersuche-und-monitoring`). Der Inhalt des Blocks ist unverändert.

```text
# Lehrplan Kontrollfrage 3: +norecurse gegen einen Resolver (SRV-LIN-BIND, Name aus der weitergeleiteten Zone lab.internal)
$ rndc flush
$ dig @192.168.50.11 testhost.lab.internal A +norecurse +noall +comments +answer
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 37904
;; flags: qr ra; QUERY: 1, ANSWER: 0, AUTHORITY: 13, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 32ea24ffff42f061010000006af494f0543557a367007a1e (good)
$ dig @192.168.50.11 testhost.lab.internal A +noall +comments +answer   (Standard, rekursiv)
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 41303
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: d1438c3fd6e09ea6010000006af494f0e587de4c1e9b40fd (good)
;; ANSWER SECTION:
testhost.lab.internal.	3600	IN	A	192.168.50.120

$ dig @192.168.50.11 testhost.lab.internal A +norecurse +noall +comments +answer   (jetzt aus dem Cache)
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 21259
;; flags: qr ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 5af343a15eb282f3010000006af494f0989297003e43c484 (good)
;; ANSWER SECTION:
testhost.lab.internal.	3600	IN	A	192.168.50.120
```
