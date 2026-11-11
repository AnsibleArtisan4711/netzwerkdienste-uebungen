<#
.SYNOPSIS
    Legt auf SRV-WIN-DNS die sekundaere Zone branch.example.org an (Uebung 06.1, Teil 2).
.DESCRIPTION
    - Add-DnsServerSecondaryZone mit Zonendatei und Primaerserver 192.168.50.11 (-ZoneFile ist Pflicht),
    - Start-DnsServerZoneTransfer loest sofort einen Transfer aus,
    - Ausgabe von Zonentyp und SOA.
    Auf SRV-LIN-BIND muss vorher allow-transfer { 192.168.50.10; }; fuer die Zone gesetzt sein.
    Als Administrator auf SRV-WIN-DNS ausfuehren. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Zone      = 'branch.example.org',
    [string]$Primaer   = '192.168.50.11',
    [string]$ZoneFile  = 'branch.example.org.dns'
)

if (Get-DnsServerZone -Name $Zone -ErrorAction SilentlyContinue) {
    Write-Host "Zone $Zone existiert bereits."
} elseif ($PSCmdlet.ShouldProcess($Zone, "Sekundaere Zone anlegen (Primaerserver $Primaer)")) {
    Add-DnsServerSecondaryZone -Name $Zone -ZoneFile $ZoneFile -MasterServers $Primaer
    Write-Host "Sekundaere Zone $Zone angelegt."
}

if ($PSCmdlet.ShouldProcess($Zone, 'Zonenuebertragung anstossen')) {
    Start-DnsServerZoneTransfer -Name $Zone
    Start-Sleep -Seconds 3
}

if (-not $WhatIfPreference) {
    Get-DnsServerZone -Name $Zone | Format-Table ZoneName, ZoneType, IsDsIntegrated -AutoSize
    Resolve-DnsName -Name $Zone -Type SOA -Server 127.0.0.1 -DnsOnly -ErrorAction SilentlyContinue | Format-List *
}
