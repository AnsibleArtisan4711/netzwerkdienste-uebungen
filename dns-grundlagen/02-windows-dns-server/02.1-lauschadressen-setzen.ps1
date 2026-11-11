<#
.SYNOPSIS
    Bindet den Windows-DNS-Server an ausgewaehlte Adressen (Uebung 02.1, Teil 2).
.DESCRIPTION
    Liest die Servereinstellungen, setzt die Eigenschaft ListeningIPAddress und schreibt das Objekt
    mit Set-DnsServerSetting zurueck. Ein eigener Parameter fuer Lauschadressen existiert bei
    Set-DnsServerSetting nicht; die Aenderung geht ueber das Einstellungsobjekt (-InputObject).
    Vorher wird geprueft, dass jede Adresse auf diesem Server wirklich konfiguriert ist, damit man sich
    nicht aussperrt. Danach wird der Dienst neu gestartet.
    Standard: 192.168.50.10 und 127.0.0.1. IPv6 (fd00:50::10, ::1) mit -MitIPv6.
    Zuruecksetzen auf "alle Adressen": -Zuruecksetzen (Hinweis siehe Uebung, nicht bestaetigt).
    Muss als Administrator auf SRV-WIN-DNS laufen. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string[]]$Adressen = @('192.168.50.10', '127.0.0.1'),
    [switch]$MitIPv6,
    [switch]$Zuruecksetzen
)

if ($MitIPv6) { $Adressen += @('fd00:50::10', '::1') }

$lokal = (Get-NetIPAddress).IPAddress
$unbekannt = $Adressen | Where-Object { $_ -notin $lokal }
if (-not $Zuruecksetzen -and $unbekannt) {
    throw "Diese Adressen sind auf dem Server nicht konfiguriert: $($unbekannt -join ', ')"
}

$einstellung = Get-DnsServerSetting -All
Write-Host ("Vorher: " + ($einstellung.ListeningIPAddress -join ', '))

if ($Zuruecksetzen) {
    $einstellung.ListeningIPAddress = $einstellung.AllIPAddress
} else {
    $einstellung.ListeningIPAddress = [System.Net.IPAddress[]]($Adressen | ForEach-Object { [System.Net.IPAddress]::Parse($_) })
}

if ($PSCmdlet.ShouldProcess('DNS-Server', "ListeningIPAddress setzen: $($einstellung.ListeningIPAddress -join ', ')")) {
    Set-DnsServerSetting -InputObject $einstellung
    Restart-Service -Name DNS
    Write-Host ("Nachher: " + ((Get-DnsServerSetting -All).ListeningIPAddress -join ', '))
}
