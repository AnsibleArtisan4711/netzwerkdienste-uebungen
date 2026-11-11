# TSIG-Transfer

Zu Modul 06: [06-zonenuebertragung-und-replikation](../06.1-zonenuebertragung-und-replikation.md). Dort steht die ausführliche Anleitung.

## Ziel

Eine Zonenübertragung mit TSIG-Schlüssel absichern und prüfen: ohne Schlüssel abgelehnt, mit Schlüssel erlaubt.

## Voraussetzungen

- Ein TSIG-Schlüssel `xfer-key` in `/etc/bind/xfer.key` (Rechte `root:bind`, `0640`) und die Testzone `tsig-test.example.org`.
- Das Geheimnis des Schlüssels darf nirgends veröffentlicht werden. Im Beispiel ist es durch `<GEHEIM>` ersetzt.

## Schritte

1. Prüfe Rechte und Aufbau der Schlüsseldatei:

   ```bash
   ls -l /etc/bind/xfer.key
   ```

2. Versuche den Zonenabzug **ohne** Schlüssel:

   ```bash
   dig @192.168.50.11 tsig-test.example.org AXFR
   ```

3. Versuche ihn **mit** Schlüssel:

   ```bash
   dig @192.168.50.11 tsig-test.example.org AXFR -k /etc/bind/xfer.key
   ```

4. Lies im Log, welche der beiden Versuche abgelehnt und welche erlaubt wurde.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# Echte Ausgaben: TSIG-gesicherter Zonenabzug (BIND 9.18.39). Das Geheimnis des Schluessels ist nicht abgedruckt.

$ ls -l /etc/bind/xfer.key
-rw-r----- 1 root bind 100 Nov 11 16:33 /etc/bind/xfer.key

$ cat /etc/bind/xfer.key        (Geheimnis ersetzt)
key "xfer-key" {
	algorithm hmac-sha256;
	secret "<GEHEIM>";
};

## Ohne Schluessel
$ dig @192.168.50.11 tsig-test.example.org AXFR
; Transfer failed.

## Logzeilen auf dem Server
11-Nov-2026 16:33:06.833 192.168.50.11#35587 (tsig-test.example.org): zone transfer 'tsig-test.example.org/AXFR/IN' denied
11-Nov-2026 16:33:06.857 192.168.50.11#43509/key xfer-key (tsig-test.example.org): transfer of 'tsig-test.example.org/IN': AXFR started: TSIG xfer-key (serial 2026111101)

## Mit Schluessel
$ dig @192.168.50.11 tsig-test.example.org AXFR -k /etc/bind/xfer.key
tsig-test.example.org.	3600	IN	SOA	linserver.branch.example.org. hostmaster.branch.example.org. 2026111101 900 300 604800 3600
tsig-test.example.org.	3600	IN	NS	linserver.branch.example.org.
host1.tsig-test.example.org. 3600 IN	A	192.168.50.55
tsig-test.example.org.	3600	IN	SOA	linserver.branch.example.org. hostmaster.branch.example.org. 2026111101 900 300 604800 3600
xfer-key.		0	ANY	TSIG	hmac-sha256. <Zeitstempel> 300 32 <Signatur> <ID> NOERROR 0
;; XFR size: 4 records (messages 1, bytes 306)
```

## So liest du die Ausgabe

- Ohne Schlüssel: `; Transfer failed.`, im Log `denied`.
- Mit Schlüssel: `AXFR started: TSIG xfer-key`, und die Antwort endet mit einem `TSIG`-Eintrag. Er enthält Zeitstempel und Signatur, die Antwort ist also signiert.
- `hmac-sha256` ist der Algorithmus. Dateirechte `-rw-r-----` verhindern, dass beliebige Benutzer das Geheimnis lesen.

## Selbst ausprobieren

Erzeuge einen eigenen Schlüssel mit `tsig-keygen` und führe die Schritte damit durch. **Das Geheimnis kommt nie in ein Repository.**
