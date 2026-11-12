# Beispiel: DORA-Mitschnitt zum Vergleich mit dem Windows-Server

> Echte Ausgabe aus dem Linux-Testlauf (Ubuntu 24.04, Netzwerk-Namespaces statt Hyper-V, `tcpdump` 4.99.4, ISC DHCP 4.4.3-P1, Kea 2.4.1). Die MAC-Adressen sind zufällig erzeugte Testwerte. Windows wurde hier **nicht** mitgeschnitten.

Dieser Ablauf stammt von einem **Kea-Server** hinter einem Relay, nicht von einem Windows-Server. Er zeigt, wie die Felder aussehen, nach denen du in deinem Mitschnitt suchst:

- Option 53 (`DHCP-Message`): Discover, Offer, Request, ACK
- Option 1, 3, 6, 15: Subnetzmaske, Router, DNS-Server, Domänenname (die Basisoptionen aus Übung 02.1)
- Option 51, 58, 59: Lease-Zeit 28800 s (8 Stunden), T1 = 14400 s, T2 = 25200 s
- Option 54: Adresse des antwortenden Servers

Dein Windows-Mitschnitt kann sich in der Reihenfolge der Optionen und in zusätzlichen Optionen unterscheiden; das Aussehen auf dem Windows-Server ist *nicht bestätigt*.

**Serverseite** (zwischen Relay `192.168.10.1` und Server `192.168.10.21`), `tcpdump -nvv`:

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

Die Meldung `bad udp cksum` kommt von Checksum-Offload auf dem aufzeichnenden Rechner und ist kein Übertragungsfehler.
