# Wirkung des Rate-Limits

Zu Modul 10: [10-dns-sicherheit-und-haertung](../10.1-dns-sicherheit-und-haertung.md). Dort steht die ausführliche Anleitung.

## Ziel

Die Wirkung von Response Rate Limiting (RRL) messen: Zu viele gleiche Antworten an dasselbe Netz werden verworfen.

## Voraussetzungen

- In den `options` steht `rate-limit { responses-per-second 10; window 5; };` (im Modul zuerst mit `log-only yes;`).
- Das Ergebnis hängt von Rechnergeschwindigkeit und Zeitfenster ab. Die genaue Zahl wirst du anders erhalten.

## Schritte

1. Schicke in einer Schleife 150 gleiche Abfragen und zähle die Ergebnisse:

   ```bash
   for i in $(seq 1 150); do
     dig -b 192.168.50.100 +tries=1 +time=1 +ignore @192.168.50.11 linserver.branch.example.org A +noall +comments 2>&1 \
       | grep -oE ';; flags: [a-z ]*|;; no servers could be reached'
   done | sort | uniq -c
   ```

2. Suche im Log nach den Meldungen von RRL:

   ```bash
   sudo grep -i "rate limit" /var/log/syslog | tail
   ```

   Die Protokolldatei hängt von deinem Logging ab (Modul 11). Im Testlabor lag das Log in einer eigenen Datei.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# 150 Anfragen in Folge aus 192.168.50.100 an linserver.branch.example.org (rate-limit: responses-per-second 10, window 5)
    138 ;; flags: qr aa rd ra
     12 ;; no servers could be reached

# Ausschnitt aus dem BIND-Log:
11-Nov-2026 17:13:40.710 192.168.50.100#42631 (linserver.branch.example.org): rate limit drop response to 192.168.50.0/24 for linserver.branch.example.org IN A  (a17530f3)
11-Nov-2026 17:13:41.894 192.168.50.100#59332 (linserver.branch.example.org): rate limit slip response to 192.168.50.0/24 for linserver.branch.example.org IN A  (a17530f3)
11-Nov-2026 17:13:41.918 192.168.50.100#42983 (linserver.branch.example.org): rate limit drop response to 192.168.50.0/24 for linserver.branch.example.org IN A  (a17530f3)
```

## So liest du die Ausgabe

- 138 Abfragen erhielten eine Antwort, 12 bekamen keine (`no servers could be reached`). Das Limit hat sie verworfen.
- `rate limit drop response`: Die Antwort wurde nicht gesendet. `rate limit slip response`: Es wurde nur eine gekürzte Antwort geschickt, damit echte Clients per TCP erneut anfragen können.
- Im Test wurde das TC-Flag der gekürzten Antworten in `dig` **nicht** beobachtet, nur die Logzeilen.
- RRL schützt vor Verstärkungsangriffen. Setze die Werte so, dass normale Clients nie betroffen sind.

## Selbst ausprobieren

Setze testweise `responses-per-second` höher und beobachte, dass weniger Abfragen verworfen werden.
