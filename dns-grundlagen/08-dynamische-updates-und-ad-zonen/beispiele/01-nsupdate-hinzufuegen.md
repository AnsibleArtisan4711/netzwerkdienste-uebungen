# nsupdate: Eintrag hinzufügen

Beispielausgabe zu Modul 08 (`08-dynamische-updates-und-ad-zonen`). Der Inhalt des Blocks ist unverändert.

```text
$ dig @192.168.50.11 branch.example.org SOA +short   # Seriennummer vorher
linserver.branch.example.org. hostmaster.branch.example.org. 2026111104 900 300 604800 3600
$ nsupdate -k /etc/bind/ddns.key
(Update gesendet, keine Fehlermeldung)
$ dig @192.168.50.11 dynhost.branch.example.org A +noall +answer
dynhost.branch.example.org. 300	IN	A	192.168.50.77
$ dig @192.168.50.11 branch.example.org SOA +short   # Seriennummer nachher
linserver.branch.example.org. hostmaster.branch.example.org. 2026111105 900 300 604800 3600
$ dig @192.168.50.10 dynhost.branch.example.org A +noall +answer   # Sekundaerserver (Windows-Stellvertreter)
dynhost.branch.example.org. 300	IN	A	192.168.50.77
$ ls -l /var/lib/bind
-rw-r--r-- 1 bind bind 1059 Nov 11 16:33 db.branch.example.org
-rw-r--r-- 1 bind bind  804 Nov 11 16:52 db.branch.example.org.jnl
```
