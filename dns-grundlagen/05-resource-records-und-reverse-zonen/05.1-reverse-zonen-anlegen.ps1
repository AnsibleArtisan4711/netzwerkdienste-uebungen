<#
.SYNOPSIS
    Legt auf SRV-WIN-DNS die Reverse-Zonen fuer 192.168.50.0/24 und fd00:50::/64 samt PTR-Eintraegen an (Uebung 05.1, Teil 2).
.DESCRIPTION
    - IPv4: Zone 50.168.192.in-addr.arpa (Datei 50.168.192.in-addr.arpa.dns)
    - IPv6: Zone 0.0.0.0.0.0.0.0.0.5.0.0.0.0.d.f.ip6.arpa (Datei <Zonenname>.dns)
    - PTR fuer winserver.corp.example.com (192.168.50.10, fd00:50::10)
      und linserver.branch.example.org (192.168.50.11, fd00:50::11)
    Der Zonenname wird von Windows aus -NetworkId abgeleitet (Beschreibung von -NetworkId in Microsoft Learn).
    Das Skript prueft nach dem Anlegen, ob der erwartete Zonenname entstanden ist, und bricht sonst ab.
    Als Administrator ausfuehren. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Verantwortlich = 'hostmaster.corp.example.com'
)

$zonen = @(
    @{ NetworkId = '192.168.50.0/24'; Name = '50.168.192.in-addr.arpa' },
    @{ NetworkId = 'fd00:50::/64';    Name = '0.0.0.0.0.0.0.0.0.5.0.0.0.0.d.f.ip6.arpa' }
)

foreach ($z in $zonen) {
    if (Get-DnsServerZone -Name $z.Name -ErrorAction SilentlyContinue) {
        Write-Host "Zone $($z.Name) existiert bereits."
    } elseif ($PSCmdlet.ShouldProcess($z.Name, "Reverse-Zone fuer $($z.NetworkId) anlegen")) {
        Add-DnsServerPrimaryZone -NetworkId $z.NetworkId -ZoneFile "$($z.Name).dns" -ResponsiblePerson $Verantwortlich
        if (-not (Get-DnsServerZone -Name $z.Name -ErrorAction SilentlyContinue)) {
            throw "Erwartete Zone $($z.Name) ist nicht entstanden. Mit Get-DnsServerZone pruefen, welchen Namen Windows vergeben hat."
        }
        Write-Host "Zone $($z.Name) angelegt."
    }
}

# PTR-Eintraege: Name = Teil der Adresse, der im Zonennamen nicht enthalten ist
$ptr = @(
    @{ Zone = '50.168.192.in-addr.arpa';                         Name = '10';                               Ziel = 'winserver.corp.example.com' },
    @{ Zone = '50.168.192.in-addr.arpa';                         Name = '11';                               Ziel = 'linserver.branch.example.org' },
    @{ Zone = '0.0.0.0.0.0.0.0.0.5.0.0.0.0.d.f.ip6.arpa';       Name = '0.1.0.0.0.0.0.0.0.0.0.0.0.0.0.0'; Ziel = 'winserver.corp.example.com' },
    @{ Zone = '0.0.0.0.0.0.0.0.0.5.0.0.0.0.d.f.ip6.arpa';       Name = '1.1.0.0.0.0.0.0.0.0.0.0.0.0.0.0'; Ziel = 'linserver.branch.example.org' }
)

foreach ($p in $ptr) {
    $vorhanden = Get-DnsServerResourceRecord -ZoneName $p.Zone -Name $p.Name -RRType PTR -ErrorAction SilentlyContinue
    if ($vorhanden) {
        Write-Host "vorhanden  PTR  $($p.Name).$($p.Zone)"
    } elseif ($PSCmdlet.ShouldProcess("$($p.Name).$($p.Zone)", "PTR -> $($p.Ziel)")) {
        Add-DnsServerResourceRecord -ZoneName $p.Zone -Ptr -Name $p.Name -PtrDomainName $p.Ziel
        Write-Host "angelegt   PTR  $($p.Name).$($p.Zone) -> $($p.Ziel)"
    }
}

if (-not $WhatIfPreference) {
    foreach ($z in $zonen) {
        Write-Host "`n== $($z.Name)"
        Get-DnsServerResourceRecord -ZoneName $z.Name -RRType PTR -ErrorAction SilentlyContinue |
            Format-Table HostName, RecordType, @{ n = 'Ziel'; e = { $_.RecordData.PtrDomainName } } -AutoSize
    }
}
