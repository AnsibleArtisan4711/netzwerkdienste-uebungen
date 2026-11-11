# Journal

Zu Modul 08: [08-dynamische-updates-und-ad-zonen](../08.1-dynamische-updates-und-ad-zonen.md). Dort steht die ausführliche Anleitung.

## Ziel

Verstehen, dass dynamische Änderungen zunächst im Journal stehen und nicht in der Zonendatei.

## Voraussetzungen

- Das Update aus dem ersten Beispiel wurde durchgeführt, noch ohne `freeze`.
- `named-journalprint` ist mit BIND installiert.

## Schritte

1. Suche den Eintrag in der Zonendatei:

   ```bash
   grep -c dynhost /var/lib/bind/db.branch.example.org
   ```

2. Lies das Journal:

   ```bash
   sudo named-journalprint /var/lib/bind/db.branch.example.org.jnl
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
$ grep -c dynhost /var/lib/bind/db.branch.example.org   # Eintrag steht noch nicht in der Zonendatei
0
$ sudo named-journalprint /var/lib/bind/db.branch.example.org.jnl
del branch.example.org.	3600	IN	SOA	linserver.branch.example.org. hostmaster.branch.example.org. 2026111104 900 300 604800 3600
add branch.example.org.	3600	IN	SOA	linserver.branch.example.org. hostmaster.branch.example.org. 2026111105 900 300 604800 3600
add dynhost.branch.example.org. 300	IN	A	192.168.50.77
```

## So liest du die Ausgabe

- `grep -c` liefert `0`: Der Eintrag steht **nicht** in der Zonendatei.
- Das Journal zeigt Änderungen als `del`/`add`: Der alte SOA (`…104`) wird gelöscht, der neue (`…105`) und der Eintrag `dynhost` hinzugefügt.
- Folge: Eine Zonendatei von Hand zu ändern, ohne vorher `rndc freeze` zu verwenden, geht bei dynamischen Zonen schief (nächstes Beispiel).

## Selbst ausprobieren

Mache mehrere Updates und beobachte, wie das Journal wächst.
