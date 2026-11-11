<#
.SYNOPSIS
    Traegt die Uebungseintraege in die hosts-Datei ein (Uebung 01.1, Teil 1).
.DESCRIPTION
    Fuegt zwei Zeilen hinzu, die mit dem Marker "# dns-uebung-01.1" enden.
    Laeuft mehrfach ohne Doppel-Eintraege. Zum Entfernen: 01.1-hosts-aufraeumen.ps1.
    Muss in einer PowerShell als Administrator laufen. Mit -WhatIf wird nichts geschrieben.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$HostsDatei = (Join-Path $env:SystemRoot 'System32\drivers\etc\hosts')
)

$marker  = '# dns-uebung-01.1'
$eintraege = @(
    "192.168.50.10`twinserver.corp.example.com`t$marker",
    "192.168.50.11`tlinserver.corp.example.com`t$marker"
)

if (-not (Test-Path -LiteralPath $HostsDatei)) {
    throw "hosts-Datei nicht gefunden: $HostsDatei"
}

$vorhanden = Get-Content -LiteralPath $HostsDatei
foreach ($zeile in $eintraege) {
    if ($vorhanden -contains $zeile) {
        Write-Host "Schon vorhanden: $zeile"
        continue
    }
    if ($PSCmdlet.ShouldProcess($HostsDatei, "Zeile anhaengen: $zeile")) {
        Add-Content -LiteralPath $HostsDatei -Value $zeile -Encoding ASCII
        Write-Host "Eingetragen:    $zeile"
    }
}
