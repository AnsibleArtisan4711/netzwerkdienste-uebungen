<#
.SYNOPSIS
    Fragt von CLI-TEST-01 aus alle Eintragstypen der Uebung 05.1 bei beiden Servern ab (Uebung 05.1, Teil 4).
.DESCRIPTION
    Je Abfrage wird geprueft, ob mindestens ein Eintrag des gefragten Typs in der Antwort steht.
    Es wird nichts veraendert. Der Parameter -DnsOnly umgeht Cache der lokalen Namensaufloesung ueber die hosts-Datei.
    Die Eigenschaftsnamen der Antwortobjekte (NameExchange, NameTarget usw.) werden hier bewusst nicht benutzt.
#>
[CmdletBinding()]
param(
    [string]$WinServer = '192.168.50.10',
    [string]$LinServer = '192.168.50.11'
)

$tests = @(
    # Server,     Name,                           Typ
    @($WinServer, 'winserver.corp.example.com',   'A'),
    @($WinServer, 'winserver.corp.example.com',   'AAAA'),
    @($WinServer, 'files.corp.example.com',       'A'),
    @($WinServer, 'files.corp.example.com',       'AAAA'),
    @($WinServer, 'intranet.corp.example.com',    'CNAME'),
    @($WinServer, 'corp.example.com',             'MX'),
    @($WinServer, 'corp.example.com',             'TXT'),
    @($WinServer, '_sip._tcp.corp.example.com',   'SRV'),
    @($WinServer, '10.50.168.192.in-addr.arpa',   'PTR'),
    @($WinServer, '11.50.168.192.in-addr.arpa',   'PTR'),
    @($LinServer, 'linserver.branch.example.org', 'A'),
    @($LinServer, 'linserver.branch.example.org', 'AAAA'),
    @($LinServer, 'web.branch.example.org',       'A'),
    @($LinServer, 'web.branch.example.org',       'AAAA'),
    @($LinServer, 'www.branch.example.org',       'CNAME'),
    @($LinServer, 'branch.example.org',           'MX'),
    @($LinServer, 'branch.example.org',           'TXT'),
    @($LinServer, '_ldap._tcp.branch.example.org','SRV')
)

$fehler = 0
foreach ($t in $tests) {
    $server, $name, $typ = $t
    $antwort = Resolve-DnsName -Name $name -Type $typ -Server $server -DnsOnly -ErrorAction SilentlyContinue
    $treffer = @($antwort | Where-Object { $_.Type -eq $typ })
    if ($treffer.Count -gt 0) {
        '{0,-7} {1,-5} {2,-34} (@{3}, TTL {4})' -f 'OK', $typ, $name, $server, $treffer[0].TTL
    } else {
        '{0,-7} {1,-5} {2,-34} (@{3})' -f 'FEHLT', $typ, $name, $server
        $fehler++
    }
}
''
if ($fehler -eq 0) { 'Ergebnis: alles in Ordnung' } else { "Ergebnis: $fehler Abfrage(n) ohne passenden Eintrag" }
