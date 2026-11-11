<#
.SYNOPSIS
    Schaltet Aging fuer corp.example.com und das Scavenging auf dem Server ein (Uebung 08.1, Teil 3).
.DESCRIPTION
    - Zone: Alterung an, Nichtaktualisierungsintervall 7 Tage, Aktualisierungsintervall 7 Tage (Set-DnsServerZoneAging)
    - Server: Scavenging an, Zyklus 7 Tage (Set-DnsServerScavenging)
    - Anzeige: Zeitstempel der Eintraege (statische Eintraege haben keinen Zeitstempel)
    Ein Eintrag kann fruehestens nach Nichtaktualisierungs- plus Aktualisierungsintervall (hier 14 Tage) aufgeraeumt werden.
    Als Administrator ausfuehren. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Zone = 'corp.example.com',
    [timespan]$NoRefresh = [timespan]::FromDays(7),
    [timespan]$Refresh = [timespan]::FromDays(7),
    [timespan]$Zyklus = [timespan]::FromDays(7)
)

if ($PSCmdlet.ShouldProcess($Zone, "Aging an (NoRefresh $NoRefresh, Refresh $Refresh)")) {
    Set-DnsServerZoneAging -Name $Zone -Aging $true -NoRefreshInterval $NoRefresh -RefreshInterval $Refresh
}
if ($PSCmdlet.ShouldProcess('DNS-Server', "Scavenging an (Zyklus $Zyklus)")) {
    Set-DnsServerScavenging -ScavengingState $true -ScavengingInterval $Zyklus
}

if (-not $WhatIfPreference) {
    Write-Host "`n== Zonen-Aging"
    Get-DnsServerZoneAging -Name $Zone | Format-List
    Write-Host '== Server-Scavenging'
    Get-DnsServerScavenging | Format-List
    Write-Host '== Zeitstempel (leer = statischer Eintrag)'
    Get-DnsServerResourceRecord -ZoneName $Zone -RRType A |
        Format-Table HostName, Timestamp, TimeToLive -AutoSize
}
