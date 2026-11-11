# update-policy

Zu Modul 08: [08-dynamische-updates-und-ad-zonen](../08.1-dynamische-updates-und-ad-zonen.md). Dort steht die ausführliche Anleitung.

## Ziel

Ein Update auf genau einen Namen und bestimmte Typen beschränken (`update-policy`).

## Voraussetzungen

- In der Zone gilt statt `allow-update` eine `update-policy`, die dem Schlüssel nur `dyn2.branch.example.org` für die Typen `A` und `TXT` erlaubt.
- `allow-update` und `update-policy` dürfen nicht gleichzeitig in einer Zone stehen.

## Schritte

1. Füge den erlaubten Namen hinzu (in `nsupdate`: `update add dyn2.branch.example.org 300 A 192.168.50.79`, `send`):

   ```bash
   nsupdate -k /etc/bind/ddns.key
   ```

2. Versuche einen anderen Namen (`update add dynhost2.branch.example.org 300 A 192.168.50.80`, `send`).
3. Frage beide Namen ab:

   ```bash
   dig +short @192.168.50.11 dyn2.branch.example.org A
   dig +short @192.168.50.11 dynhost2.branch.example.org A
   ```

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# update-policy: der Schluessel darf nur dyn2.branch.example.org (Typen A und TXT) aendern
$ nsupdate -k ...   # update add dyn2.branch.example.org 300 A 192.168.50.79
(Rueckgabewert: 0)
$ nsupdate -k ...   # update add dynhost2.branch.example.org 300 A 192.168.50.80
update failed: REFUSED
(Rueckgabewert: 2)
$ dig +short @192.168.50.11 dyn2.branch.example.org A; dig +short @192.168.50.11 dynhost2.branch.example.org A
192.168.50.79
```

## So liest du die Ausgabe

- Das erste Update ist erlaubt (Rückgabewert `0`), das zweite scheitert mit `REFUSED` (Rückgabewert `2`).
- Nur `dyn2` hat eine Antwort. Der Schlüssel kann damit nicht beliebige Namen ändern.
- Das ist die sicherere Form gegenüber `allow-update { key … }`, das dem Schlüssel die ganze Zone öffnet.

## Selbst ausprobieren

Erweitere `update-policy` um den Typ `AAAA` und teste mit einem IPv6-Eintrag.
