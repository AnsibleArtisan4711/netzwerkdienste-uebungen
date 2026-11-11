<#
.SYNOPSIS
    Richtet auf SRV-WIN-DNS die Split-Brain-Aufloesung per DNS-Richtlinie ein oder entfernt sie wieder (Uebung 09.1, Teil 4).
.DESCRIPTION
    Einrichten (Standard):
      1. Client-Subnetz DMZ-Subnet = 192.168.60.0/24
      2. Zonenscope DMZ-Scope in corp.example.com
      3. Eintrag files im Standard-Scope (192.168.50.20) und im DMZ-Scope (192.168.60.20)
      4. Richtlinie DMZ-Policy: Clients aus DMZ-Subnet bekommen Antworten aus DMZ-Scope
    Mit -Entfernen werden Richtlinie, Scope-Eintraege, Scope und Client-Subnetz wieder geloescht
    (Aufraeumen am Ende der Uebung). Der Eintrag files im Standard-Scope bleibt, es sei denn -AuchStandardEintrag wird angegeben.
    Als Administrator ausfuehren. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Zone = 'corp.example.com',
    [string]$SubnetName = 'DMZ-Subnet',
    [string]$Subnetz = '192.168.60.0/24',
    [string]$ScopeName = 'DMZ-Scope',
    [string]$PolicyName = 'DMZ-Policy',
    [string]$HostName = 'files',
    [string]$IpIntern = '192.168.50.20',
    [string]$IpDmz = '192.168.60.20',
    [switch]$Entfernen,
    [switch]$AuchStandardEintrag
)

if (-not $Entfernen) {
    if ($PSCmdlet.ShouldProcess($SubnetName, "Client-Subnetz $Subnetz anlegen")) {
        Add-DnsServerClientSubnet -Name $SubnetName -IPv4Subnet $Subnetz
    }
    if ($PSCmdlet.ShouldProcess($Zone, "Zonenscope $ScopeName anlegen")) {
        Add-DnsServerZoneScope -ZoneName $Zone -Name $ScopeName
    }
    if ($PSCmdlet.ShouldProcess("$HostName.$Zone", "A $IpIntern im Standard-Scope")) {
        Add-DnsServerResourceRecord -ZoneName $Zone -A -Name $HostName -IPv4Address $IpIntern
    }
    if ($PSCmdlet.ShouldProcess("$HostName.$Zone", "A $IpDmz im Scope $ScopeName")) {
        Add-DnsServerResourceRecord -ZoneName $Zone -ZoneScope $ScopeName -A -Name $HostName -IPv4Address $IpDmz
    }
    if ($PSCmdlet.ShouldProcess($PolicyName, "Richtlinie anlegen: $SubnetName -> $ScopeName")) {
        Add-DnsServerQueryResolutionPolicy -Name $PolicyName -Action ALLOW -ClientSubnet "eq,$SubnetName" -ZoneScope "$ScopeName,1" -ZoneName $Zone
    }
    if (-not $WhatIfPreference) {
        Write-Host "`n== Richtlinien der Zone $Zone"
        Get-DnsServerQueryResolutionPolicy -ZoneName $Zone | Format-Table Name, Action, ProcessingOrder, IsEnabled -AutoSize
    }
}
else {
    if ($PSCmdlet.ShouldProcess($PolicyName, 'Richtlinie entfernen')) {
        Remove-DnsServerQueryResolutionPolicy -Name $PolicyName -ZoneName $Zone -Force
    }
    if ($PSCmdlet.ShouldProcess($ScopeName, "Eintrag $HostName im Scope entfernen")) {
        Remove-DnsServerResourceRecord -ZoneName $Zone -ZoneScope $ScopeName -RRType A -Name $HostName -Force
    }
    if ($PSCmdlet.ShouldProcess($ScopeName, 'Zonenscope entfernen')) {
        Remove-DnsServerZoneScope -ZoneName $Zone -Name $ScopeName -Force
    }
    if ($PSCmdlet.ShouldProcess($SubnetName, 'Client-Subnetz entfernen')) {
        Remove-DnsServerClientSubnet -Name $SubnetName -Force
    }
    if ($AuchStandardEintrag -and $PSCmdlet.ShouldProcess("$HostName.$Zone", 'Eintrag im Standard-Scope entfernen')) {
        Remove-DnsServerResourceRecord -ZoneName $Zone -RRType A -Name $HostName -Force
    }
}
