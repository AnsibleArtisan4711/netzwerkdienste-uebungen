# Querylog

Beispielausgabe zu Modul 11 (`11-fehlersuche-und-monitoring`). Der Inhalt des Blocks ist unverändert.

```text
$ sudo rndc querylog on
$ (vier Abfragen)
$ sudo rndc querylog off
$ (eine weitere Abfrage; steht nicht im Log)
$ sudo cat /var/log/named/queries.log
11-Nov-2026 17:17:37.982 queries: client 192.168.50.11#36276 (www.branch.example.org): query: www.branch.example.org IN A +E(0)K (192.168.50.11)
11-Nov-2026 17:17:38.010 queries: client 192.168.50.11#53964 (linserver.branch.example.org): query: linserver.branch.example.org IN A +E(0)K (192.168.50.11)
11-Nov-2026 17:17:38.034 queries: client 192.168.50.11#41212 (nichtda.branch.example.org): query: nichtda.branch.example.org IN A +E(0)K (192.168.50.11)
11-Nov-2026 17:17:38.054 queries: client 192.168.50.100#35669 (testhost.lab.internal): query: testhost.lab.internal IN AAAA +E(0)K (192.168.50.11)
```
