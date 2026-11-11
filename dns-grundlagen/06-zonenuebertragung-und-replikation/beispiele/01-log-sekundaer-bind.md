# Log des BIND-Sekundärservers

Beispielausgabe zu Modul 06 (`06-zonenuebertragung-und-replikation`). Der Inhalt des Blocks ist unverändert.

```text
# Echte Logzeilen von SRV-LIN-BIND (BIND 9.18.39, Sekundaerserver fuer corp.example.com; Primaerserver war ein BIND als Stellvertreter fuer SRV-WIN-DNS).
# In der Uebung lesen Sie diese Zeilen mit:  sudo journalctl -u named -n 40 --no-pager   (Vorspann von journald weicht ab)

## 1. Erste Uebertragung nach rndc reconfig (AXFR)
11-Nov-2026 16:32:24.065 zone corp.example.com/IN: Transfer started.
11-Nov-2026 16:32:24.065 zone corp.example.com/IN: transferred serial 2026111102
11-Nov-2026 16:32:24.065 transfer of 'corp.example.com/IN' from 192.168.50.10#53: Transfer status: success
11-Nov-2026 16:32:24.065 transfer of 'corp.example.com/IN' from 192.168.50.10#53: Transfer completed: 1 messages, 14 records, 447 bytes, 0.001 secs (447000 bytes/sec) (serial 2026111102)

## 2. NOTIFY des Primaerservers nach Aenderung (Seriennummer erhoeht), danach Uebertragung
11-Nov-2026 16:32:33.785 client @0x7f588d3a5ac8 192.168.50.10#39024: received notify for zone 'corp.example.com'
11-Nov-2026 16:32:33.785 zone corp.example.com/IN: notify from 192.168.50.10#39024: serial 2026111103

## 3. Die Primaer-Seite derselben Uebertragung (IXFR, inkrementell)
11-Nov-2026 16:32:33.785 192.168.50.11#35907 (corp.example.com): transfer of 'corp.example.com/IN': IXFR started (serial 2026111102 -> 2026111103)
11-Nov-2026 16:32:33.785 192.168.50.11#35907 (corp.example.com): transfer of 'corp.example.com/IN': IXFR ended: 1 messages, 5 records, 227 bytes, 0.001 secs (227000 bytes/sec) (serial 2026111103)
```
