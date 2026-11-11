# Reihenfolge der Views

Beispielausgabe zu Modul 09 (`09-split-brain-dns`). Der Inhalt des Blocks ist unverändert.

```text
# Reihenfolge der Views: der erste passende match-clients gewinnt
# dmz-View (match-clients 192.168.0.0/16, also ueberlappend) steht HINTER internal:
$ dig -b 192.168.50.100 +short @192.168.50.11 www.branch.example.org A
192.168.50.40
# dmz-View steht jetzt VOR internal:
$ dig -b 192.168.50.100 +short @192.168.50.11 www.branch.example.org A
192.168.60.40
```
