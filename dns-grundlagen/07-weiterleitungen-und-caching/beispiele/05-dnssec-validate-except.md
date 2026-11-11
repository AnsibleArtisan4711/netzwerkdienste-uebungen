# DNSSEC: validate-except

Zu Modul 07: [07-weiterleitungen-und-caching](../07.1-weiterleitungen-und-caching.md). Dort steht die ausführliche Anleitung.

## Ziel

Verstehen, warum die DNSSEC-Prüfung im isolierten Labor eine Weiterleitung stören kann, und wie `validate-except` hilft.

## Voraussetzungen

- SRV-LIN-BIND mit `dnssec-validation auto;` leitet `lab.internal` an `192.168.50.10` weiter.
- Das Labor hat keine Verbindung zu den Root-Servern, es gibt für `lab.internal` keinen Vertrauensanker.

## Schritte

1. Frage den Namen ab und lies den Status:

   ```bash
   dig @192.168.50.11 testhost.lab.internal A
   ```

2. Suche im Log nach `broken trust chain`.
3. Trage im `options`-Block ein: `validate-except { "lab.internal"; };`, prüfe und lade neu:

   ```bash
   sudo named-checkconf
   sudo rndc reload
   ```

4. Wiederhole die Abfrage aus Schritt 1.

## Ausgabe

Mitschnitt aus dem Testlauf, unverändert. Zeitstempel, IDs, Cookies und Seriennummern sehen bei dir anders aus.

```text
# Ohne validate-except: Weiterleitung auf lab.internal scheitert im Labor (keine Verbindung zu den Root-Servern)
$ dig @192.168.50.11 testhost.lab.internal A
;; status: SERVFAIL
# Logmeldung (journalctl -u named; im Testlabor die Ausgabe von named)
11-Nov-2026 16:47:07.842 broken trust chain resolving 'testhost.lab.internal/A/IN': 192.168.50.10#53

# Mit validate-except { "lab.internal"; }; im options-Block
$ dig @192.168.50.11 testhost.lab.internal A
status: NOERROR
testhost.lab.internal.	3600	IN	A	192.168.50.120
```

## So liest du die Ausgabe

- Vorher: `SERVFAIL`, im Log `broken trust chain`. BIND kann die Signaturkette nicht bis zur Wurzel prüfen.
- Nachher: `NOERROR` mit Adresse. Für `lab.internal` wird die Prüfung ausgesetzt.
- `validate-except` nur für interne Zonen setzen. Die Prüfung für alle anderen Namen bleibt bestehen.

## Selbst ausprobieren

Setze `validate-except` wieder zurück und beobachte, wann der Fehler erneut auftritt.
