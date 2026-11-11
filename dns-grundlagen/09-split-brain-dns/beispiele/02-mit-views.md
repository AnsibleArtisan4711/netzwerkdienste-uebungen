# Mit Views

Beispielausgabe zu Modul 09 (`09-split-brain-dns`). Der Inhalt des Blocks ist unverändert.

```text
# Mit Views: gleiche Frage, andere Antwort je nach Quelladresse
$ dig -b 192.168.50.100 +short @192.168.50.11 www.branch.example.org A     # Quelle im internen Netz
web.branch.example.org.
192.168.50.40
$ dig -b 192.168.60.100 +short @192.168.60.11 www.branch.example.org A     # Quelle im DMZ-Netz
web.branch.example.org.
192.168.60.40
$ dig -b 192.168.60.100 @192.168.60.11 linserver.branch.example.org AAAA +short   # im DMZ-View nicht vorhanden
(leer)
$ dig -b 192.168.60.100 @192.168.60.11 corp.example.com SOA     # Zone gibt es im DMZ-View nicht
status: REFUSED
flags: qr rd
$ dig -b 192.168.60.100 @192.168.60.11 www.example.org A     # Rekursion im DMZ-View verboten
status: REFUSED
flags: qr rd
$ dig -b 192.168.50.100 @192.168.60.11 corp.example.com SOA +short   # internes Netz fragt die .60-Adresse
winserver.corp.example.com. hostmaster.corp.example.com. 2026111103 900 300 604800 3600
```
