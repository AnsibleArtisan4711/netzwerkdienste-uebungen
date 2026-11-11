<#
.SYNOPSIS
    Richtet auf SRV-WIN-DNS die bedingte Weiterleitung fuer partner.example.net ein und legt optional die Zone lab.internal an (Uebung 07.1, Teile 2 und 3).
.DESCRIPTION
    - Bedingte Weiterleitung: partner.example.net -> 192.168.50.11 (SRV-LIN-BIND), Add-DnsServerConditionalForwarderZone.
    - Mit -MitLabInternal: dateibasierte primaere Zone lab.internal mit dem Host testhost (192.168.50.120).
      SRV-LIN-BIND leitet lab.internal in Teil 3 an diesen Server weiter.
    - Globale Weiterleitungen werden NICHT gesetzt: das Labor hat keinen Internetzugang.
    Als Administrator ausfuehren. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$PartnerZone   = 'partner.example.net',
    [string[]]$PartnerServer = @('192.168.50.11'),
    [switch]$MitLabInternal
)

# 1. Bedingte Weiterleitung
if (Get-DnsServerZone -Name $PartnerZone -ErrorAction SilentlyContinue) {
    Write-Host "Zone $PartnerZone existiert bereits (Typ mit Get-DnsServerZone pruefen)."
} elseif ($PSCmdlet.ShouldProcess($PartnerZone, "Bedingte Weiterleitung an $($PartnerServer -join ', ') anlegen")) {
    Add-DnsServerConditionalForwarderZone -Name $PartnerZone -MasterServers $PartnerServer
    Write-Host "Bedingte Weiterleitung $PartnerZone -> $($PartnerServer -join ', ') angelegt."
}

# 2. Optional: lab.internal als eigene Zone
if ($MitLabInternal) {
    if (Get-DnsServerZone -Name 'lab.internal' -ErrorAction SilentlyContinue) {
        Write-Host 'Zone lab.internal existiert bereits.'
    } elseif ($PSCmdlet.ShouldProcess('lab.internal', 'primaere Zone mit testhost anlegen')) {
        Add-DnsServerPrimaryZone -Name 'lab.internal' -ZoneFile 'lab.internal.dns' -DynamicUpdate None
        Add-DnsServerResourceRecordA -ZoneName 'lab.internal' -Name 'testhost' -IPv4Address '192.168.50.120' -TimeToLive ([TimeSpan]::FromHours(1))
        Write-Host 'Zone lab.internal mit testhost angelegt.'
    }
}

if (-not $WhatIfPreference) {
    Write-Host "`n== Zonen"
    Get-DnsServerZone | Where-Object { $_.ZoneName -in @($PartnerZone, 'lab.internal') } |
        Format-Table ZoneName, ZoneType, IsDsIntegrated -AutoSize
    Write-Host '== Globale Weiterleitungen'
    Get-DnsServerForwarder
}
