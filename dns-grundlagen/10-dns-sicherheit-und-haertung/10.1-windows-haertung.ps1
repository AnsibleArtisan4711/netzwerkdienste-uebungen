<#
.SYNOPSIS
    Prueft und haertet den Windows-DNS-Server SRV-WIN-DNS (Uebung 10.1, Teil 2).
.DESCRIPTION
    Ohne Schalter wird nur gelesen: Socket Pool, Cache Locking, Response Rate Limiting.
    -Haerten setzt Cache Locking auf 100 und Response Rate Limiting auf den Modus aus -RrlModus (Standard LogOnly).
    -Zuruecksetzen stellt Cache Locking auf 100 (Standardwert) und RRL auf Disable zurueck.
    Mit -WhatIf wird nichts geaendert. Als Administrator auf SRV-WIN-DNS ausfuehren.
    Nicht bestaetigt: Eigenschaftsname SocketPoolSize in Get-DnsServerSetting (bei Abweichung: Get-DnsServerSetting -All | Get-Member).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$Haerten,
    [switch]$Zuruecksetzen,
    [ValidateSet('LogOnly', 'Enable')]
    [string]$RrlModus = 'LogOnly'
)

function Zeige-Stand {
    Write-Host '== Socket Pool (Source Port Randomization)'
    $set = Get-DnsServerSetting -All
    if ($set.PSObject.Properties.Name -contains 'SocketPoolSize') {
        Write-Host ("SocketPoolSize = {0}" -f $set.SocketPoolSize)
    } else {
        Write-Warning 'Eigenschaft SocketPoolSize nicht gefunden (nicht bestaetigt). Pruefen mit: Get-DnsServerSetting -All | Get-Member'
    }
    Write-Host "`n== Cache Locking"
    Get-DnsServerCache | Select-Object LockingPercent, MaxTTL, MaxNegativeTTL, EnablePollutionProtection | Format-List
    Write-Host '== Response Rate Limiting'
    Get-DnsServerResponseRateLimiting | Format-List
}

Zeige-Stand

if ($Haerten -and $PSCmdlet.ShouldProcess('SRV-WIN-DNS', "Cache Locking 100, RRL $RrlModus")) {
    Set-DnsServerCache -LockingPercent 100
    Set-DnsServerResponseRateLimiting -Mode $RrlModus
    Write-Host "`nGehaertet: LockingPercent 100, RRL-Modus $RrlModus"
    Zeige-Stand
}

if ($Zuruecksetzen -and $PSCmdlet.ShouldProcess('SRV-WIN-DNS', 'Cache Locking 100, RRL Disable')) {
    Set-DnsServerCache -LockingPercent 100
    Set-DnsServerResponseRateLimiting -Mode Disable
    Write-Host "`nZurueckgesetzt: RRL Disable (LockingPercent bleibt 100, in der Beispielausgabe von Microsoft Learn steht ebenfalls 100)."
    Zeige-Stand
}
