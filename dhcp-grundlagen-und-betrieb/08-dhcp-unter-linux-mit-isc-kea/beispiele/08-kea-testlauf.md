# Beispiel: Kea 2.4.1, Testlauf

> Echte Ausgabe aus dem Linux-Testlauf (Ubuntu 24.04, Netzwerk-Namespaces statt Hyper-V, `tcpdump` 4.99.4, ISC DHCP 4.4.3-P1, Kea 2.4.1). Die MAC-Adressen sind zufällig erzeugte Testwerte. Windows wurde hier **nicht** mitgeschnitten.

## 1 Start und DORA mit dynamischem Pool

Konfiguration: wie `08.1-kea-dhcp4.conf`, im Test mit Schnittstelle `sa`. Auszug aus der Ausgabe (gekürzt auf die wichtigen Zeilen; die Spalte mit Prozess-ID wurde entfernt):

```text
2026-11-12 00:58:04.616 INFO  [kea-dhcp4.dhcp4/716.139884335675840] DHCP4_STARTING Kea DHCPv4 server version 2.4.1 (stable) starting
2026-11-12 00:58:04.617 INFO  [kea-dhcp4.dhcpsrv] DHCPSRV_CFGMGR_NEW_SUBNET4 a new subnet has been added to configuration: 192.168.30.0/24 with params: t1=14400, t2=25200, valid-lifetime=28800
2026-11-12 00:58:04.617 INFO  [kea-dhcp4.dhcpsrv] DHCPSRV_CFGMGR_ADD_IFACE listening on interface sa
2026-11-12 00:58:04.617 INFO  [kea-dhcp4.dhcp4/716.139884335675840] DHCP4_CONFIG_COMPLETE DHCPv4 server has completed configuration: added IPv4 subnets: 1; DDNS: disabled
2026-11-12 00:58:04.639 INFO  [kea-dhcp4.dhcp4/716.139884335675840] DHCP4_STARTED Kea DHCPv4 server version 2.4.1 started
2026-11-12 00:58:18.844 INFO  [kea-dhcp4.leases] DHCP4_LEASE_ADVERT [hwtype=1 d6:8a:0f:27:69:76], cid=[no info], tid=0x34552042: lease 192.168.30.100 will be advertised
2026-11-12 00:58:18.844 INFO  [kea-dhcp4.leases] DHCP4_LEASE_ALLOC [hwtype=1 d6:8a:0f:27:69:76], cid=[no info], tid=0x34552042: lease 192.168.30.100 has been allocated for 28800 seconds
```

## 2 Mit Reservierung

Gleiche Konfiguration plus Reservierung (`08.1-kea-dhcp4-reservierung.conf`, MAC des Testclients):

```text
2026-11-12 00:59:54.464 INFO  [kea-dhcp4.leases] DHCP4_LEASE_ADVERT [hwtype=1 d6:8a:0f:27:69:76], cid=[no info], tid=0x55e7f735: lease 192.168.30.50 will be advertised
2026-11-12 00:59:54.464 INFO  [kea-dhcp4.leases] DHCP4_LEASE_ALLOC [hwtype=1 d6:8a:0f:27:69:76], cid=[no info], tid=0x55e7f735: lease 192.168.30.50 has been allocated for 28800 seconds
```

## 3 Lease-Datei nach den Tests

Die Datei wird angehängt; die dritte Zeile ist die freigegebene Lease (`valid_lifetime` 0):

```text
address,hwaddr,client_id,valid_lifetime,expire,subnet_id,fqdn_fwd,fqdn_rev,hostname,state,user_context,pool_id
192.168.30.100,d6:8a:0f:27:69:76,,28800,1794470298,1,0,0,vm,0,,0
192.168.30.50,d6:8a:0f:27:69:76,,28800,1794470394,1,0,0,cli-lin-b,0,,0
192.168.30.100,d6:8a:0f:27:69:76,,0,1794441498,1,0,0,vm,0,,0
```

## 4 Fehler: Schnittstelle existiert nicht (`kea-dhcp4 -t`)

```text
DHCP4_PARSER_FAIL failed to create or run parser for configuration element interfaces-config: Failed to select interface: interface 'eth9' doesn't exist in the system (/tmp/lab/bad.conf:4:23) (/tmp/lab/bad.conf:4:7)
Error encountered: Failed to select interface: interface 'eth9' doesn't exist in the system (/tmp/lab/bad.conf:4:23) (/tmp/lab/bad.conf:4:7)
```

## 5 Fehler: kein passendes Subnetz

Ein Client aus einem Netz ohne `subnet4` (Absender des Relays `192.168.10.1`): Kea antwortet nicht, im Log steht:

```text
2026-11-12 00:59:31.795 ERROR [kea-dhcp4.bad-packets] DHCP4_PACKET_NAK_0001 [hwtype=1 be:70:df:c7:f3:cb], cid=[no info], tid=0x7b65b556: failed to select a subnet for incoming packet, src 192.168.10.1, type DHCPDISCOVER
2026-11-12 00:59:34.734 ERROR [kea-dhcp4.bad-packets] DHCP4_PACKET_NAK_0001 [hwtype=1 be:70:df:c7:f3:cb], cid=[no info], tid=0x7b65b556: failed to select a subnet for incoming packet, src 192.168.10.1, type DHCPDISCOVER
2026-11-12 00:59:39.672 ERROR [kea-dhcp4.bad-packets] DHCP4_PACKET_NAK_0001 [hwtype=1 be:70:df:c7:f3:cb], cid=[no info], tid=0x7b65b556: failed to select a subnet for incoming packet, src 192.168.10.1, type DHCPDISCOVER
```

## 6 DHCPv6 (nicht lauffähig im Test)

Kea6 startete in der Testumgebung nicht, weil das Verzeichnis für die DUID-Datei nicht beschreibbar war:

```text
2026-11-12 01:00:29.266 ERROR [kea-dhcp6.dhcp6] DHCP6_INIT_FAIL failed to initialize Kea server: configuration error using file 'kea-dhcp6.conf': unable to configure server identifier: unable to open DUID file /var/lib/kea/kea-dhcp6-serverid for writing
```

Außerdem hatte der Kernel der Testumgebung keinen IPv6-Stack. Das Relay meldete:

```text
Can't create dhcp socket for rb: Address family not supported by protocol
```
