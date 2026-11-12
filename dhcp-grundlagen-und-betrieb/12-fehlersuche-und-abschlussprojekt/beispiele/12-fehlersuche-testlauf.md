# Beispiel: Echte Fehlermeldungen aus dem Testlauf

> Echte Ausgabe aus dem Linux-Testlauf (Ubuntu 24.04, Netzwerk-Namespaces statt Hyper-V, `tcpdump` 4.99.4, ISC DHCP 4.4.3-P1, Kea 2.4.1). Die MAC-Adressen sind zufällig erzeugte Testwerte. Windows wurde hier **nicht** mitgeschnitten.

| Fehlerbild | Beobachtete Meldung |
|---|---|
| Schnittstelle existiert nicht | siehe Abschnitt 1 |
| Kein passendes Subnetz | siehe Abschnitt 2 |
| Kea6 ohne Schreibrecht für die DUID-Datei | siehe Abschnitt 3 |
| Relay ohne IPv6 | siehe Abschnitt 4 |

## 1 `kea-dhcp4 -t` mit falscher Schnittstelle

```text
DHCP4_PARSER_FAIL failed to create or run parser for configuration element interfaces-config: Failed to select interface: interface 'eth9' doesn't exist in the system (/tmp/lab/bad.conf:4:23) (/tmp/lab/bad.conf:4:7)
Error encountered: Failed to select interface: interface 'eth9' doesn't exist in the system (/tmp/lab/bad.conf:4:23) (/tmp/lab/bad.conf:4:7)
```

## 2 Server ohne Subnetz für das Netz des Clients

Serverlog:

```text
2026-11-12 01:07:39.713 ERROR [kea-dhcp4.bad-packets] DHCP4_PACKET_NAK_0001 [hwtype=1 be:70:df:c7:f3:cb], cid=[no info], tid=0xb6539b48: failed to select a subnet for incoming packet, src 192.168.10.1, type DHCPDISCOVER
```

Client (`dhclient -v`) sendet DISCOVER im Abstand von mehreren Sekunden und bekommt kein OFFER. Mitschnitt auf der Serverseite: das DISCOVER kommt an, eine Antwort bleibt aus (siehe `05-relay-mitschnitt.md`, Abschnitt 3).

## 3 Kea6 ohne beschreibbares Verzeichnis

```text
2026-11-12 01:00:29.266 ERROR [kea-dhcp6.dhcp6] DHCP6_INIT_FAIL failed to initialize Kea server: configuration error using file 'kea-dhcp6.conf': unable to configure server identifier: unable to open DUID file /var/lib/kea/kea-dhcp6-serverid for writing
```

## 4 Relay ohne IPv6-Unterstützung

```text
Can't create dhcp socket for rb: Address family not supported by protocol
```

Beide letzten Fälle sind Eigenheiten der Testumgebung und kein Fehlerbild für das Hyper-V-Labor.
