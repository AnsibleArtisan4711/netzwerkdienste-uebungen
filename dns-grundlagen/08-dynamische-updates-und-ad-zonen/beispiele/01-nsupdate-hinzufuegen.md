# nsupdate: Eintrag hinzufügen

Zu Modul 08: [08-dynamische-updates-und-ad-zonen](../08.1-dynamische-updates-und-ad-zonen.md). Dort steht die ausführliche Anleitung.

## Ziel

Einen Eintrag per dynamischem Update (`nsupdate`) mit TSIG-Schlüssel hinzufügen und die Folgen prüfen: Seriennummer, Sekundärserver, Journal.

## Voraussetzungen

- Die Zone `branch.example.org` auf SRV-LIN-BIND hat `allow-update { key "ddns-key"; };` und liegt in `/var/lib/bind`.
- Der Schlüssel liegt in `/etc/bind/ddns.key`. Sein Geheimnis gehört nie in ein Dokument oder Repository.
- Die Befehlsdatei `08.1-nsupdate-dynhost.txt` enthält `server`, `zone`, `update add …` und `send`.

## Schritte

1. Notiere die Seriennummer vor dem Update:

   ```bash
   dig @192.168.50.11 branch.example.org SOA +short
   ```

2. Sende das Update. Interaktiv tippst du die Zeilen ein, Abschluss mit `send` und `Strg+D`, oder du übergibst die Datei:

   ```bash
   nsupdate -k /etc/bind/ddns.key 08.1-nsupdate-dynhost.txt
   ```

3. Prüfe den neuen Eintrag und die Seriennummer:

   ```bash
   dig @192.168.50.11 dynhost.branch.example.org A +noall +answer
   dig @192.168.50.11 branch.example.org SOA +short
   ```

4. Frage den Sekundärserver ab und sieh dir das Verzeichnis der Zone an:

   ```bash
   dig @192.168.50.10 dynhost.branch.example.org A +noall +answer
   ls -l /var/lib/bind
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus. Der Windows-Server wurde im Test durch eine zweite BIND-Instanz ersetzt. **Echte Windows-Ausgaben können abweichen.**

```text
$ dig @192.168.50.11 branch.example.org SOA +short   # Seriennummer vorher
linserver.branch.example.org. hostmaster.branch.example.org. 2026111104 900 300 604800 3600
$ nsupdate -k /etc/bind/ddns.key
(Update gesendet, keine Fehlermeldung)
$ dig @192.168.50.11 dynhost.branch.example.org A +noall +answer
dynhost.branch.example.org. 300	IN	A	192.168.50.77
$ dig @192.168.50.11 branch.example.org SOA +short   # Seriennummer nachher
linserver.branch.example.org. hostmaster.branch.example.org. 2026111105 900 300 604800 3600
$ dig @192.168.50.10 dynhost.branch.example.org A +noall +answer   # Sekundaerserver (Windows-Stellvertreter)
dynhost.branch.example.org. 300	IN	A	192.168.50.77
$ ls -l /var/lib/bind
-rw-r--r-- 1 bind bind 1059 Nov 11 16:33 db.branch.example.org
-rw-r--r-- 1 bind bind  804 Nov 11 16:52 db.branch.example.org.jnl
```

## So liest du die Ausgabe

- `nsupdate` meldet bei Erfolg nichts. Die Kontrolle ist die Abfrage.
- Die Seriennummer steigt von `…104` auf `…105`, BIND erhöht sie bei jedem Update selbst.
- Der Sekundärserver hat den Eintrag ebenfalls: BIND schickt ein NOTIFY, der Sekundärserver holt die Änderung (IXFR).
- Neben der Zonendatei steht jetzt `db.branch.example.org.jnl`: das **Journal**, in dem BIND die Änderungen sammelt (nächstes Beispiel).

## Selbst ausprobieren

Lösche den Eintrag mit `update delete dynhost.branch.example.org A` und `send`.
