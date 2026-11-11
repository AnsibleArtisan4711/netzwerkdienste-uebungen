# Update ohne Schlüssel

Zu Modul 08: [08-dynamische-updates-und-ad-zonen](../08.1-dynamische-updates-und-ad-zonen.md). Dort steht die ausführliche Anleitung.

## Ziel

Prüfen, dass ein Update ohne Schlüssel abgelehnt wird.

## Voraussetzungen

- Dieselbe Zone wie im vorigen Beispiel, `allow-update` nur für `ddns-key`.

## Schritte

1. Starte `nsupdate` **ohne** `-k` und sende ein Update (zum Beispiel `update add evil.branch.example.org 300 A 192.168.50.99`, danach `send`):

   ```bash
   nsupdate
   ```

2. Lies die Fehlermeldung und prüfe den Rückgabewert mit `echo $?`.
3. Frage den Namen ab:

   ```bash
   dig @192.168.50.11 evil.branch.example.org A +noall +comments | grep -o "status: [A-Z]*"
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
$ nsupdate    # ohne Schluessel
update failed: REFUSED
(Rueckgabewert: 2)
$ dig @192.168.50.11 evil.branch.example.org A +noall +comments | grep -o "status: [A-Z]*"
status: NXDOMAIN
```

## So liest du die Ausgabe

- `update failed: REFUSED`: Der Server hat das Update abgelehnt, weil die Signatur fehlt.
- Rückgabewert `2` zeigt den Fehler an, wichtig für Skripte.
- `status: NXDOMAIN`: Der Eintrag wurde nicht angelegt.

## Selbst ausprobieren

Sende dasselbe Update mit `nsupdate -k /etc/bind/ddns.key` und vergleiche das Ergebnis.
