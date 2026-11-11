; Vergleichsdatei: So koennten die Eintraege der Windows-Zone corp.example.com als BIND-Zonendatei aussehen.
; Auf SRV-WIN-DNS legst du sie mit PowerShell oder GUI an (Skript 05.1-corp-records-anlegen.ps1).
$TTL 3600
@         IN  SOA winserver.corp.example.com. hostmaster.corp.example.com. (
              2026111101 900 300 604800 3600 )
@         IN  NS    winserver.corp.example.com.
@         IN  MX    10 mail.corp.example.com.
@         IN  TXT   "v=spf1 mx -all"

winserver IN  A     192.168.50.10
winserver IN  AAAA  fd00:50::10
files     IN  A     192.168.50.20
files     IN  AAAA  fd00:50::20
mail      IN  A     192.168.50.25
voip      IN  A     192.168.50.30

intranet  IN  CNAME files.corp.example.com.

_sip._tcp IN  SRV   10 100 5060 voip.corp.example.com.
