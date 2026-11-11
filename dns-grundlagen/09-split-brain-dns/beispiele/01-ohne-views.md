# Ohne Views

Beispielausgabe zu Modul 09 (`09-split-brain-dns`). Der Inhalt des Blocks ist unverändert.

```text
# Vor den Views: dieselbe Antwort fuer beide Subnetze
$ dig -b 192.168.50.100 +short @192.168.50.11 www.branch.example.org A
web.branch.example.org.
192.168.50.40
$ dig -b 192.168.60.100 +short @192.168.60.11 www.branch.example.org A
web.branch.example.org.
192.168.50.40
```
