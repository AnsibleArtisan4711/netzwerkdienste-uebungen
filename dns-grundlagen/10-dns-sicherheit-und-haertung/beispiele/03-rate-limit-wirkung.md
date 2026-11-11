# Wirkung des Rate-Limits

Beispielausgabe zu Modul 10 (`10-dns-sicherheit-und-haertung`). Der Inhalt des Blocks ist unverändert.

```text
# 150 Anfragen in Folge aus 192.168.50.100 an linserver.branch.example.org (rate-limit: responses-per-second 10, window 5)
    138 ;; flags: qr aa rd ra
     12 ;; no servers could be reached

# Ausschnitt aus dem BIND-Log:
11-Nov-2026 17:13:40.710 192.168.50.100#42631 (linserver.branch.example.org): rate limit drop response to 192.168.50.0/24 for linserver.branch.example.org IN A  (a17530f3)
11-Nov-2026 17:13:41.894 192.168.50.100#59332 (linserver.branch.example.org): rate limit slip response to 192.168.50.0/24 for linserver.branch.example.org IN A  (a17530f3)
11-Nov-2026 17:13:41.918 192.168.50.100#42983 (linserver.branch.example.org): rate limit drop response to 192.168.50.0/24 for linserver.branch.example.org IN A  (a17530f3)
```
