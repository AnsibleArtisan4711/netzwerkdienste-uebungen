# TSIG-Transfer

Beispielausgabe zu Modul 06 (`06-zonenuebertragung-und-replikation`). Der Inhalt des Blocks ist unverändert.

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
