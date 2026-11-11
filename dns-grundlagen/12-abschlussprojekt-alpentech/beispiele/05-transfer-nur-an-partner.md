# Transfer nur an den Partner

Beispielausgabe zu Modul 12 (`12-abschlussprojekt-alpentech`). Der Inhalt des Blocks ist unverändert.

```text
# Zonentransfer nur an den Partner (AXFR mit dig -b <Quelladresse>)
von 192.168.50.100 an 192.168.50.10 fuer hq.alpentech.internal: ; Transfer failed.
von 192.168.50.11 an 192.168.50.10 fuer hq.alpentech.internal: ;; XFR size: 16 records (messages 1, bytes 552)
von 192.168.50.100 an 192.168.50.11 fuer dev.alpentech.internal: ; Transfer failed.
von 192.168.50.10 an 192.168.50.11 fuer dev.alpentech.internal: ;; XFR size: 16 records (messages 1, bytes 546)
# Sekundaere Kopien geben nichts heraus (allow-transfer { none; })
von 192.168.50.10 an 192.168.50.11 fuer hq.alpentech.internal: ; Transfer failed.
von 192.168.50.11 an 192.168.50.10 fuer dev.alpentech.internal: ; Transfer failed.
# Reverse-Zonen (nur an den Partner)
von 192.168.50.100 an 192.168.50.10 fuer 50.168.192.in-addr.arpa: ; Transfer failed.
von 192.168.50.11 an 192.168.50.10 fuer 50.168.192.in-addr.arpa: ;; XFR size: 12 records (messages 1, bytes 451)
von 192.168.50.100 an 192.168.50.10 fuer 0.0.0.0.0.0.0.0.0.5.0.0.0.0.d.f.ip6.arpa: ; Transfer failed.
von 192.168.50.11 an 192.168.50.10 fuer 0.0.0.0.0.0.0.0.0.5.0.0.0.0.d.f.ip6.arpa: ;; XFR size: 11 records (messages 1, bytes 656)
```
