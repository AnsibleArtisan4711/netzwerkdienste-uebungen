# AXFR abgelehnt und offen

Beispielausgabe zu Modul 06 (`06-zonenuebertragung-und-replikation`). Der Inhalt des Blocks ist unverändert.

```text
# Echte Ausgaben: Zonenabzug durch einen nicht freigegebenen Absender (192.168.50.100). BIND 9.18.39.

$ dig @192.168.50.11 branch.example.org AXFR     (Absender 192.168.50.100, allow-transfer nur fuer 192.168.50.10)
; <<>> DiG 9.18.39-0ubuntu0.24.04.9-Ubuntu <<>> -b 192.168.50.100 @192.168.50.11 branch.example.org AXFR
; Transfer failed.

## Logzeile auf dem angefragten Server
11-Nov-2026 16:35:57.105 192.168.50.100#35917 (branch.example.org): zone transfer 'branch.example.org/AXFR/IN' denied

## Zum Vergleich: ohne allow-transfer (BIND-Standard) liefert derselbe Abzug die ganze Zone (11 Eintraege)
11-Nov-2026 16:32:23.985 192.168.50.100#46675 (branch.example.org): transfer of 'branch.example.org/IN': AXFR started (serial 2026111101)
11-Nov-2026 16:32:23.985 192.168.50.100#46675 (branch.example.org): transfer of 'branch.example.org/IN': AXFR ended: 1 messages, 11 records, 412 bytes, 0.001 secs (412000 bytes/sec) (serial 2026111101)
```
