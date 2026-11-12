# Beispiel: DORA-Mitschnitt auf der Client-Seite (Netz C)

> Echte Ausgabe aus dem Linux-Testlauf (Ubuntu 24.04, Netzwerk-Namespaces statt Hyper-V, `tcpdump` 4.99.4, ISC DHCP 4.4.3-P1, Kea 2.4.1). Die MAC-Adressen sind zufällig erzeugte Testwerte. Windows wurde hier **nicht** mitgeschnitten.

Mitschnitt mit `tcpdump -nev` auf der Seite des Clients (`rc` am Router). Vier Nachrichten:

| Nr. | Zeit | Quelle → Ziel | Nachricht | Besonderheit |
|---|---|---|---|---|
| 1 | 00:58:18.843 | `0.0.0.0:68` → `255.255.255.255:67` | DISCOVER | Broadcast, Client hat noch keine Adresse |
| 2 | 00:58:18.844 | `192.168.30.1:67` → `192.168.30.100:68` | OFFER | angebotene Adresse `192.168.30.100`, Lease 28800 s |
| 3 | 00:58:18.844 | `0.0.0.0:68` → `255.255.255.255:67` | REQUEST | nennt Server-ID und gewünschte Adresse (Option 50) |
| 4 | 00:58:18.844 | `192.168.30.1:67` → `192.168.30.100:68` | ACK | gleiche Optionen wie das OFFER |

Beachte: Der Absender von OFFER und ACK ist der **Relay** (`192.168.30.1`); der eigentliche Server steht nur in Option 54 (`Server-ID`).

```text
tcpdump: listening on rc, link-type EN10MB (Ethernet), snapshot length 262144 bytes
00:58:18.843433 d6:8a:0f:27:69:76 > ff:ff:ff:ff:ff:ff, ethertype IPv4 (0x0800), length 342: (tos 0x10, ttl 128, id 0, offset 0, flags [none], proto UDP (17), length 328)
    0.0.0.0.68 > 255.255.255.255.67: [udp sum ok] BOOTP/DHCP, Request from d6:8a:0f:27:69:76, length 300, xid 0x34552042, Flags [none] (0x0000)
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
00:58:18.844173 92:2e:2b:55:98:d6 > d6:8a:0f:27:69:76, ethertype IPv4 (0x0800), length 350: (tos 0x10, ttl 128, id 0, offset 0, flags [none], proto UDP (17), length 336)
    192.168.30.1.67 > 192.168.30.100.68: [udp sum ok] BOOTP/DHCP, Reply, length 308, hops 1, xid 0x34552042, Flags [none] (0x0000)
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
00:58:18.844272 d6:8a:0f:27:69:76 > ff:ff:ff:ff:ff:ff, ethertype IPv4 (0x0800), length 342: (tos 0x10, ttl 128, id 0, offset 0, flags [none], proto UDP (17), length 328)
    0.0.0.0.68 > 255.255.255.255.67: [udp sum ok] BOOTP/DHCP, Request from d6:8a:0f:27:69:76, length 300, xid 0x34552042, Flags [none] (0x0000)
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
00:58:18.844688 92:2e:2b:55:98:d6 > d6:8a:0f:27:69:76, ethertype IPv4 (0x0800), length 350: (tos 0x10, ttl 128, id 0, offset 0, flags [none], proto UDP (17), length 336)
    192.168.30.1.67 > 192.168.30.100.68: [udp sum ok] BOOTP/DHCP, Reply, length 308, hops 1, xid 0x34552042, Flags [none] (0x0000)
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
