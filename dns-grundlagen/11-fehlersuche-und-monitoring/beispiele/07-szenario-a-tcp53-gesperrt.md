# Szenario A: TCP 53 gesperrt

Zu Modul 11: [11-fehlersuche-und-monitoring](../11.1-fehlersuche-und-monitoring.md). Dort steht die ausführliche Anleitung.

## Ziel

Das Szenario „TCP 53 gesperrt“ nachstellen: UDP-Abfragen gehen, Zonentransfers scheitern.

## Voraussetzungen

- SRV-LIN-BIND ist Sekundär für `corp.example.com`, Primär ist `192.168.50.10` (im Test BIND-Stellvertreter).
- Im Testlabor blockierte `iptables` mit `REJECT tcp-reset`. Die Windows-Firewall blockiert dagegen meist **still**, dann gibt es Zeitüberschreitungen statt `connection refused`.
- Die Regel danach wieder entfernen!

## Schritte

1. Sperre TCP 53 zum Primärserver (Test: nur im Labor!). Unter Windows mit einer Firewallregel, im Test mit `iptables`.
2. Prüfe UDP und TCP:

   ```bash
   dig +time=3 +tries=1 @192.168.50.10 corp.example.com SOA +short
   dig @192.168.50.10 corp.example.com AXFR
   ```

3. Löse eine Übertragung aus und lies das Log:

   ```bash
   sudo rndc retransfer corp.example.com
   ```

4. Optional: Mitschnitt mit `tcpdump`:

   ```bash
   sudo tcpdump -i any port 53 -nn
   ```

5. Entferne die Sperre und wiederhole Schritt 3.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus. Der Windows-Server wurde im Test durch eine zweite BIND-Instanz ersetzt. **Echte Windows-Ausgaben können abweichen.**

```text
# Szenario A: TCP 53 zum Windows-Server blockiert (hier im Testlabor mit iptables REJECT tcp-reset; Windows Defender Firewall blockiert ueblicherweise still, dann gibt es Zeitueberschreitungen)
$ dig +time=3 +tries=1 @192.168.50.10 corp.example.com SOA +short   (UDP, funktioniert)
winserver.corp.example.com. hostmaster.corp.example.com. 2026111103 900 300 604800 3600
$ dig @192.168.50.10 corp.example.com AXFR   (TCP)
;; Connection to 192.168.50.10#53(192.168.50.10) for corp.example.com failed: connection refused.
;; no servers could be reached
$ sudo rndc retransfer corp.example.com
# BIND-Log (Auszug):
11-Nov-2026 17:18:38.482 xfer-in: zone corp.example.com/IN: Transfer started.
11-Nov-2026 17:18:38.482 xfer-in: transfer of 'corp.example.com/IN' from 192.168.50.10#53: failed to connect: connection refused
11-Nov-2026 17:18:38.482 xfer-in: transfer of 'corp.example.com/IN' from 192.168.50.10#53: Transfer status: connection refused
11-Nov-2026 17:18:38.482 xfer-in: transfer of 'corp.example.com/IN' from 192.168.50.10#53: Transfer completed: 0 messages, 0 records, 0 bytes, 0.001 secs (0 bytes/sec) (serial 0)
11-Nov-2026 17:18:38.482 general: received control channel command 'retransfer corp.example.com'

# tcpdump (Auszug, Schnittstelle lo, nur TCP-Port 53): SYN wird mit RST beantwortet
IP 192.168.50.11.46385 > 192.168.50.10.53: Flags [S]
IP 192.168.50.10.53 > 192.168.50.11.46385: Flags [R.]
IP 192.168.50.11.38093 > 192.168.50.10.53: Flags [S]
IP 192.168.50.10.53 > 192.168.50.11.38093: Flags [R.]

# Nach dem Entfernen der Regel
$ sudo rndc retransfer corp.example.com
11-Nov-2026 17:18:56.370 xfer-in: zone corp.example.com/IN: transferred serial 2026111103
11-Nov-2026 17:18:56.370 xfer-in: transfer of 'corp.example.com/IN' from 192.168.50.10#53: Transfer status: success
11-Nov-2026 17:18:56.370 xfer-in: transfer of 'corp.example.com/IN' from 192.168.50.10#53: Transfer completed: 1 messages, 15 records, 475 bytes, 0.001 secs (475000 bytes/sec) (serial 2026111103)
```

## So liest du die Ausgabe

- UDP antwortet, TCP scheitert mit `connection refused`: Kleine Abfragen funktionieren, Zonentransfers nicht.
- Das Log zeigt `failed to connect: connection refused` und `Transfer completed: 0 messages`.
- `tcpdump`: Auf jedes `SYN` (`Flags [S]`) folgt ein `RST` (`Flags [R.]`) vom Server. Bei stiller Sperre würde das `RST` fehlen.
- Nach Entfernen der Sperre: `Transfer status: success`.

## Selbst ausprobieren

Prüfe nach dem Test, dass die Regel `TEST-Blockiere-TCP53` wirklich entfernt ist.
