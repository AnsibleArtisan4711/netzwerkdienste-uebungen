<#
.SYNOPSIS
    Zeigt Scopes mit hoher Auslastung und protokolliert sie auf Wunsch in einer Textdatei (Uebung 10.1, Teil 1).
.DESCRIPTION
    Liest Get-DhcpServerv4ScopeStatistics und meldet Scopes ab einer Schwelle (Standard 80 Prozent,
    Eigenschaft PercentageInUse, laut Microsoft-Learn-Beispiel vorhanden).
    Optional: -Protokoll schreibt jede Meldung mit Zeitstempel an eine Textdatei.
    Auf dem DHCP-Server ausfuehren. Aendert nichts am Server; -WhatIf betrifft nur die Textdatei.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [int]$SchwellePro = 80,
    [string]$Protokoll
)

$stat = Get-DhcpServerv4ScopeStatistics -ErrorAction Stop
$treffer = $stat | Where-Object { $_.PercentageInUse -gt $SchwellePro }
if (-not $treffer) {
    Write-Host "Kein Scope ueber $SchwellePro Prozent."
} else {
    foreach ($t in $treffer) {
        $zeile = '{0:yyyy-MM-dd HH:mm:ss} Scope {1}: {2:N1} Prozent belegt' -f (Get-Date), $t.ScopeId, $t.PercentageInUse
        Write-Warning $zeile
        if ($Protokoll -and $PSCmdlet.ShouldProcess($Protokoll, 'Zeile anhaengen')) {
            Add-Content -Path $Protokoll -Value $zeile -Encoding UTF8
        }
    }
}
$stat | Select-Object ScopeId, PercentageInUse
