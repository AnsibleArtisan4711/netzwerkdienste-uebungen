<#
.SYNOPSIS
    Entfernt die Uebungseintraege aus der hosts-Datei und leert den DNS-Clientcache (Uebung 01.1, Teil 1).
.DESCRIPTION
    Entfernt nur Zeilen, die den Marker "# dns-uebung-01.1" enthalten. Alle anderen Zeilen bleiben unveraendert.
    Vor dem Schreiben wird eine Sicherung "hosts.bak-uebung" neben die Datei gelegt.
    Muss in einer PowerShell als Administrator laufen. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$HostsDatei = (Join-Path $env:SystemRoot 'System32\drivers\etc\hosts')
)

$marker = '# dns-uebung-01.1'

if (-not (Test-Path -LiteralPath $HostsDatei)) {
    throw "hosts-Datei nicht gefunden: $HostsDatei"
}

$alle     = Get-Content -LiteralPath $HostsDatei
$behalten = $alle | Where-Object { $_ -notlike "*$marker*" }
$entfernt = @($alle).Count - @($behalten).Count

if ($entfernt -eq 0) {
    Write-Host 'Keine Uebungseintraege gefunden, nichts zu tun.'
} elseif ($PSCmdlet.ShouldProcess($HostsDatei, "$entfernt Zeile(n) entfernen")) {
    Copy-Item -LiteralPath $HostsDatei -Destination "$HostsDatei.bak-uebung" -Force
    Set-Content -LiteralPath $HostsDatei -Value $behalten -Encoding ASCII
    Write-Host "$entfernt Zeile(n) entfernt. Sicherung: $HostsDatei.bak-uebung"
}

if ($PSCmdlet.ShouldProcess('DNS-Clientcache', 'leeren')) {
    Clear-DnsClientCache
    Write-Host 'DNS-Clientcache geleert.'
}
