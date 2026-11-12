# Beispiel: Relay-Ablauf mit Kea (Netz C)

> Echte Ausgabe aus dem Linux-Testlauf (Ubuntu 24.04, Netzwerk-Namespaces statt Hyper-V, `tcpdump` 4.99.4, ISC DHCP 4.4.3-P1, Kea 2.4.1). Die MAC-Adressen sind zufällig erzeugte Testwerte. Windows wurde hier **nicht** mitgeschnitten.

## 1 Serverseite: Relay → Server

Der Relay (`192.168.10.1`) leitet DISCOVER und REQUEST an den Server `192.168.10.21` weiter. Erkennbar an `hops 1` und `Gateway-IP 192.168.30.1` (`giaddr`), an der der Server das Subnetz auswählt:

```text
tcpdump: listening on ra, link-type EN10MB (Ethernet), snapshot length 262144 bytes
00:58:18.843516 IP (tos 0x0, ttl 64, id 24648, offset 0, flags [DF], proto UDP (17), length 328)
    192.168.10.1.67 > 192.168.10.21.67: [bad udp cksum 0x96ac -> 0x9b92!] BOOTP/DHCP, Request from d6:8a:0f:27:69:76, length 300, hops 1, xid 0x34552042, Flags [none] (0x0000)
	  Gateway-IP 192.168.30.1
	  Client-Ethernet-Address d6:8a:0f:27:69:76
	  Vendor-rfc1048 Extensions
	    Magic Cookie 0x63825363
	    DHCP-Message (53), length 1: Discover
	    Hostname (12), length 2: "vm"
	    Parameter-Request (55), length 13: 
	      Subnet-Mask (1), BR (28), Time-Zone (2), Default-Gateway (3)
	      Domain-Name (15), Domain-Name-Server (6), Unknown (119), Hostname (12)
	      Netbios-Name-Server (44), Netbios-Scope (47), MTU (26), Classless-Static-Route (121)
	      NTP (42)
00:58:18.844101 IP (tos 0x10, ttl 128, id 0, offset 0, flags [DF], proto UDP (17), length 336)
    192.168.10.21.67 > 192.168.30.1.67: [udp sum ok] BOOTP/DHCP, Reply, length 308, hops 1, xid 0x34552042, Flags [none] (0x0000)
	  Your-IP 192.168.30.100
	  Gateway-IP 192.168.30.1
	  Client-Ethernet-Address d6:8a:0f:27:69:76
	  Vendor-rfc1048 Extensions
	    Magic Cookie 0x63825363
	    DHCP-Message (53), length 1: Offer
	    Subnet-Mask (1), length 4: 255.255.255.0
	    Default-Gateway (3), length 4: 192.168.30.1
	    Domain-Name-Server (6), length 4: 192.168.10.10
	    Hostname (12), length 2: "vm"
	    Domain-Name (15), length 16: "corp.example.com"
	    Lease-Time (51), length 4: 28800
	    Server-ID (54), length 4: 192.168.10.21
	    RN (58), length 4: 14400
	    RB (59), length 4: 25200
00:58:18.844295 IP (tos 0x0, ttl 64, id 24649, offset 0, flags [DF], proto UDP (17), length 328)
    192.168.10.1.67 > 192.168.10.21.67: [bad udp cksum 0x96ac -> 0xc680!] BOOTP/DHCP, Request from d6:8a:0f:27:69:76, length 300, hops 1, xid 0x34552042, Flags [none] (0x0000)
	  Gateway-IP 192.168.30.1
	  Client-Ethernet-Address d6:8a:0f:27:69:76
	  Vendor-rfc1048 Extensions
	    Magic Cookie 0x63825363
	    DHCP-Message (53), length 1: Request
	    Server-ID (54), length 4: 192.168.10.21
	    Requested-IP (50), length 4: 192.168.30.100
	    Hostname (12), length 2: "vm"
	    Parameter-Request (55), length 13: 
	      Subnet-Mask (1), BR (28), Time-Zone (2), Default-Gateway (3)
	      Domain-Name (15), Domain-Name-Server (6), Unknown (119), Hostname (12)
	      Netbios-Name-Server (44), Netbios-Scope (47), MTU (26), Classless-Static-Route (121)
	      NTP (42)
00:58:18.844639 IP (tos 0x10, ttl 128, id 0, offset 0, flags [DF], proto UDP (17), length 336)
    192.168.10.21.67 > 192.168.30.1.67: [udp sum ok] BOOTP/DHCP, Reply, length 308, hops 1, xid 0x34552042, Flags [none] (0x0000)
	  Your-IP 192.168.30.100
	  Gateway-IP 192.168.30.1
	  Client-Ethernet-Address d6:8a:0f:27:69:76
	  Vendor-rfc1048 Extensions
	    Magic Cookie 0x63825363
	    DHCP-Message (53), length 1: ACK
	    Subnet-Mask (1), length 4: 255.255.255.0
	    Default-Gateway (3), length 4: 192.168.30.1
	    Domain-Name-Server (6), length 4: 192.168.10.10
	    Hostname (12), length 2: "vm"
	    Domain-Name (15), length 16: "corp.example.com"
	    Lease-Time (51), length 4: 28800
	    Server-ID (54), length 4: 192.168.10.21
	    RN (58), length 4: 14400
	    RB (59), length 4: 25200
4 packets captured
4 packets received by filter
0 packets dropped by kernel
```

## 2 Log des Relays (`dhcrelay` 4.4.3-P1)

```text
Requesting: ra as upstream: Y downstream: Y
Requesting: rb as upstream: Y downstream: Y
Requesting: rc as upstream: Y downstream: Y
Internet Systems Consortium DHCP Relay Agent 4.4.3-P1
Copyright 2004-2022 Internet Systems Consortium.
All rights reserved.
For info, please visit https://www.isc.org/software/dhcp/
Listening on LPF/rc/92:2e:2b:55:98:d6
Sending on   LPF/rc/92:2e:2b:55:98:d6
Listening on LPF/rb/ee:ff:a2:96:bb:bd
Sending on   LPF/rb/ee:ff:a2:96:bb:bd
Listening on LPF/ra/6e:56:25:6f:18:49
Sending on   LPF/ra/6e:56:25:6f:18:49
Sending on   Socket/fallback
Forwarded BOOTREQUEST for d6:8a:0f:27:69:76 to 192.168.10.21
BOOTREPLY giaddr: 192.168.30.1

Forwarded BOOTREPLY for d6:8a:0f:27:69:76 to 192.168.30.100
Forwarded BOOTREQUEST for d6:8a:0f:27:69:76 to 192.168.10.21
BOOTREPLY giaddr: 192.168.30.1

Forwarded BOOTREPLY for d6:8a:0f:27:69:76 to 192.168.30.100
Forwarded BOOTREQUEST for be:70:df:c7:f3:cb to 192.168.10.21
Forwarded BOOTREQUEST for be:70:df:c7:f3:cb to 192.168.10.21
Forwarded BOOTREQUEST for be:70:df:c7:f3:cb to 192.168.10.21
Forwarded BOOTREQUEST for d6:8a:0f:27:69:76 to 192.168.10.21
BOOTREPLY giaddr: 192.168.30.1

Forwarded BOOTREPLY for d6:8a:0f:27:69:76 to 192.168.30.50
Forwarded BOOTREQUEST for d6:8a:0f:27:69:76 to 192.168.10.21
BOOTREPLY giaddr: 192.168.30.1

Forwarded BOOTREPLY for d6:8a:0f:27:69:76 to 192.168.30.50
```

Die Zeilen `Forwarded BOOTREQUEST … to 192.168.10.21` zeigen die Weiterleitung, `Forwarded BOOTREPLY … to 192.168.30.100` die Antwort an den Client. Die drei BOOTREQUEST-Zeilen für `be:70:df:c7:f3:cb` stammen von einem zweiten Client in einem Netz ohne Subnetz auf dem Server (keine Antwort, siehe Modul 12).

## 3 Zwei Server am selben Relay

Mit `SERVERS="192.168.10.21 192.168.10.12"` leitet der Relay **jede** Anfrage an beide Server. Nur der Server mit passendem Subnetz antwortete (hier `192.168.10.12` für Netz B). Mitschnitt auf der Serverseite:

```text
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on br-a, link-type EN10MB (Ethernet), snapshot length 262144 bytes
01:07:39.712127 IP 192.168.10.1.67 > 192.168.10.21.67: BOOTP/DHCP, Request from be:70:df:c7:f3:cb, length 300
01:07:39.712180 IP 192.168.10.1.67 > 192.168.10.12.67: BOOTP/DHCP, Request from be:70:df:c7:f3:cb, length 300
01:07:39.713432 IP 192.168.10.12.67 > 192.168.20.1.67: BOOTP/DHCP, Reply, length 308
01:07:39.713673 IP 192.168.10.1.67 > 192.168.10.21.67: BOOTP/DHCP, Request from be:70:df:c7:f3:cb, length 300
4 packets captured
6 packets received by filter
0 packets dropped by kernel
```

Die erste und zweite Zeile zeigen die gleichzeitige Weiterleitung an beide Server, die dritte die Antwort von `192.168.10.12`. Die vierte Zeile ist die Weiterleitung der folgenden Client-Nachricht (vermutlich das REQUEST) an `192.168.10.21`; dieser Server hat kein passendes Subnetz und schweigt.
