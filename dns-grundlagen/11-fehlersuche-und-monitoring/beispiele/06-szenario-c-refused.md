# Szenario C: REFUSED

Zu Modul 11: [11-fehlersuche-und-monitoring](../11.1-fehlersuche-und-monitoring.md). Dort steht die ausführliche Anleitung.

## Ziel

Das Szenario „REFUSED durch fehlende ACL“ nachstellen und im Log (`security.log`) belegen.

## Voraussetzungen

- `acl "lab-nets"` enthält `192.168.50.0/24;` und `allow-query { lab-nets; };` ist gesetzt (Modul 3).
- Sichere vorher die Datei: `sudo cp -a /etc/bind/named.conf.options /etc/bind/named.conf.options.vor-szenario-c`.

## Schritte

1. Entferne `192.168.50.0/24;` aus der ACL, prüfe und lade neu:

   ```bash
   sudo named-checkconf
   sudo rndc reload
   ```

2. Frage aus dem Netz ab:

   ```bash
   dig -b 192.168.50.100 @192.168.50.11 www.branch.example.org A
   ```

3. Suche im Log nach dem Grund:

   ```bash
   sudo cat /var/log/named/security.log
   ```

4. Stelle den Zustand wieder her und prüfe:

   ```bash
   sudo cp -a /etc/bind/named.conf.options.vor-szenario-c /etc/bind/named.conf.options && sudo rndc reload
   dig -b 192.168.50.100 @192.168.50.11 www.branch.example.org A +short
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# Szenario C: 192.168.50.0/24 aus der ACL lab-nets entfernt
$ dig -b 192.168.50.100 @192.168.50.11 www.branch.example.org A
;; ->>HEADER<<- opcode: QUERY, status: REFUSED, id: 35606
;; flags: qr rd; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1
; EDNS: version: 0, flags:; udp: 1232

$ sudo cat /var/log/named/queries.log (letzte Zeile)
11-Nov-2026 17:18:17.454 queries: client 192.168.50.100#46813 (www.branch.example.org): query: www.branch.example.org IN A +E(0)K (192.168.50.11)
$ sudo cat /var/log/named/security.log
11-Nov-2026 17:18:17.410 security: client 192.168.50.100#60312 (www.branch.example.org): query 'www.branch.example.org/A/IN' denied
11-Nov-2026 17:18:17.454 security: client 192.168.50.100#46813 (www.branch.example.org): query 'www.branch.example.org/A/IN' denied

# Wiederherstellung und Kontrollabfrage
$ sudo cp -a /etc/bind/named.conf.options.vor-szenario-c /etc/bind/named.conf.options && sudo rndc reload
$ dig -b 192.168.50.100 @192.168.50.11 www.branch.example.org A +short
web.branch.example.org.
192.168.50.40
```

## So liest du die Ausgabe

- `status: REFUSED`: Der Server ist erreichbar, aber diese Quelle darf nicht fragen.
- `security.log`: `query … denied`. Das ist der Beweis und nennt den Client.
- Im `queries.log` steht die Abfrage ebenfalls. Auch abgewiesene Abfragen werden protokolliert.
- Unter Windows meldet `Resolve-DnsName` einen ähnlichen Fehler („DNS-Server hat die Anfrage abgelehnt“, sinngemäß, *nicht bestätigt*).

## Selbst ausprobieren

Prüfe nach der Wiederherstellung mit `sudo named-checkconf`, dass keine Reste übrig sind.
