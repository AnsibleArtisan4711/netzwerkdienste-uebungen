# DNSSEC: validate-except

Beispielausgabe zu Modul 07 (`07-weiterleitungen-und-caching`). Der Inhalt des Blocks ist unverändert.

```text
# Ohne validate-except: Weiterleitung auf lab.internal scheitert im Labor (keine Verbindung zu den Root-Servern)
$ dig @192.168.50.11 testhost.lab.internal A
;; status: SERVFAIL
# Logmeldung (journalctl -u named; im Testlabor die Ausgabe von named)
11-Nov-2026 16:47:07.842 broken trust chain resolving 'testhost.lab.internal/A/IN': 192.168.50.10#53

# Mit validate-except { "lab.internal"; }; im options-Block
$ dig @192.168.50.11 testhost.lab.internal A
status: NOERROR
testhost.lab.internal.	3600	IN	A	192.168.50.120
```
