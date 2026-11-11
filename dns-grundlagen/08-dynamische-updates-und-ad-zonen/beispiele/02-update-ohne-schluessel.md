# Update ohne Schlüssel

Beispielausgabe zu Modul 08 (`08-dynamische-updates-und-ad-zonen`). Der Inhalt des Blocks ist unverändert.

```text
$ nsupdate    # ohne Schluessel
update failed: REFUSED
(Rueckgabewert: 2)
$ dig @192.168.50.11 evil.branch.example.org A +noall +comments | grep -o "status: [A-Z]*"
status: NXDOMAIN
```
