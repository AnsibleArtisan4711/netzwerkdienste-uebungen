# Nach der Rückkehr

Beispielausgabe zu Modul 09 (`09-split-brain-dns`). Der Inhalt des Blocks ist unverändert.

```text
$ dig -b 192.168.60.100 +short @192.168.60.11 www.branch.example.org A   # nach der Rueckkehr zur Konfiguration ohne Views
web.branch.example.org.
192.168.50.40
```
