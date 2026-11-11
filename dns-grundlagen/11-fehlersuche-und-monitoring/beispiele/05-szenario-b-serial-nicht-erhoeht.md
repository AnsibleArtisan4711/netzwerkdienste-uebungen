# Szenario B: Serial nicht erhöht

Beispielausgabe zu Modul 11 (`11-fehlersuche-und-monitoring`). Der Inhalt des Blocks ist unverändert.

```text
# Szenario B: A-Record geaendert, Seriennummer nicht erhoeht
$ dig +short @192.168.50.11 web.branch.example.org A   -> 192.168.50.40
Seriennummer SRV-LIN-BIND (Primaer): 2026111112   Windows-Ersatz (Sekundaer): 2026111112
$ sudo rndc freeze branch.example.org
22:web			A	192.168.50.41
$ sudo rndc thaw branch.example.org
A zone reload and thaw was started.
Check the logs to see the result.
$ sudo rndc reload branch.example.org
rndc: 'reload' failed: dynamic zone
Primaer web = 192.168.50.41   Seriennummer Primaer 2026111112
Sekundaer web = 192.168.50.40   Seriennummer Sekundaer 2026111112
# Log Sekundaer (Auszug):
11-Nov-2026 17:17:28.618 zone branch.example.org/IN: notify from 192.168.50.11#37375: zone is up to date
11-Nov-2026 17:17:50.922 client 192.168.50.11#41669: received notify for zone 'branch.example.org'
11-Nov-2026 17:17:50.922 zone branch.example.org/IN: notify from 192.168.50.11#41669: zone is up to date

# Korrektur: Seriennummer erhoehen (wieder zwischen freeze und thaw)
$ sudo rndc freeze branch.example.org
4:				2026111112 ; serial
4:				2026111113 ; serial
$ sudo rndc thaw branch.example.org
A zone reload and thaw was started.
Check the logs to see the result.
Primaer web = 192.168.50.41   Seriennummer Primaer 2026111113
Sekundaer web = 192.168.50.41   Seriennummer Sekundaer 2026111113
# Log Sekundaer (Auszug):
11-Nov-2026 17:17:59.010 transfer of 'branch.example.org/IN' from 192.168.50.11#53: Transfer status: success
11-Nov-2026 17:17:59.010 transfer of 'branch.example.org/IN' from 192.168.50.11#53: Transfer completed: 1 messages, 14 records, 455 bytes, 0.001 secs (455000 bytes/sec) (serial 2026111113)
11-Nov-2026 17:17:59.010 zone branch.example.org/IN: sending notifies (serial 2026111113)
```
