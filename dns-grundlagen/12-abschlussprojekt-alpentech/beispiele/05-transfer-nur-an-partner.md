# Transfer nur an den Partner

Zu Modul 12: [12-abschlussprojekt-alpentech](../12.1-abschlussprojekt-alpentech.md). Dort steht die ausführliche Anleitung.

## Ziel

Prüfen, dass Zonentransfers nur zwischen den beiden Servern möglich sind, auch für die Reverse-Zonen.

## Voraussetzungen

- Primärzonen erlauben die Übertragung nur an den Partner, Sekundärzonen geben nichts heraus (`allow-transfer { none; }`).
- Im Test war `192.168.50.10` eine BIND-Instanz als Stellvertreter für Windows. Unter Windows lässt sich die Einschränkung in der Zonenkonsole setzen (Reiter Zonenübertragungen).

## Schritte

1. Versuche den Abzug von einem Fremdrechner und vom Partner (`-b` setzt die Absenderadresse):

   ```bash
   dig -b 192.168.50.100 @192.168.50.10 hq.alpentech.internal AXFR
   dig -b 192.168.50.11  @192.168.50.10 hq.alpentech.internal AXFR
   dig -b 192.168.50.100 @192.168.50.11 dev.alpentech.internal AXFR
   dig -b 192.168.50.10  @192.168.50.11 dev.alpentech.internal AXFR
   ```

2. Versuche den Abzug **von der Sekundärkopie**:

   ```bash
   dig -b 192.168.50.10 @192.168.50.11 hq.alpentech.internal AXFR
   dig -b 192.168.50.11 @192.168.50.10 dev.alpentech.internal AXFR
   ```

3. Wiederhole es für die Reverse-Zonen (`50.168.192.in-addr.arpa` und die `ip6.arpa`-Zone).

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus. Der Windows-Server wurde im Test durch eine zweite BIND-Instanz ersetzt. **Echte Windows-Ausgaben können abweichen.**

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

## So liest du die Ausgabe

- Fremdrechner: `; Transfer failed.`, Partner: `XFR size: … records`.
- Auch die Sekundärkopien liefern nichts aus: Sie sind keine Quelle.
- Gleiches Ergebnis bei den Reverse-Zonen: nur der Partner darf.
- Die Zeilen sind aus mehreren Läufen zusammengefasst, nicht eine Terminalausgabe.

## Selbst ausprobieren

Ergänze einen dritten Server (nur theoretisch) und überlege, wo du `allow-transfer` anpassen müsstest.
