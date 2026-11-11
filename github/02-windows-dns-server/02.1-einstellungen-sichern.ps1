<#
.SYNOPSIS
    Sichert die Einstellungen des Windows-DNS-Servers als Textdateien (Uebung 02.1, Teil 3).
.DESCRIPTION
    Schreibt je Bereich eine Datei in den Zielordner: Servereinstellungen, Rekursion, Root Hints,
    Weiterleitungen, Cache-Einstellungen und Zonenliste. Die Dateien dienen der Dokumentation und dem
    Vergleich vor/nach Aenderungen. Es wird nichts am Server geaendert.
    Muss in einer PowerShell mit installiertem DnsServer-Modul laufen (auf SRV-WIN-DNS).
#>
[CmdletBinding()]
param(
    [string]$Ziel = 'C:\Uebung\dns-sicherung'
)

New-Item -ItemType Directory -Path $Ziel -Force | Out-Null
$zeit = Get-Date -Format 'yyyyMMdd-HHmmss'

$bereiche = [ordered]@{
    'einstellungen' = { Get-DnsServerSetting -All }
    'rekursion'     = { Get-DnsServerRecursion }
    'roothints'     = { Get-DnsServerRootHint }
    'weiterleitung' = { Get-DnsServerForwarder }
    'cache'         = { Get-DnsServerCache }
    'zonen'         = { Get-DnsServerZone }
}

foreach ($name in $bereiche.Keys) {
    $datei = Join-Path $Ziel "$zeit-$name.txt"
    try {
        & $bereiche[$name] | Format-List * | Out-String -Width 200 | Set-Content -LiteralPath $datei -Encoding UTF8
        Write-Host "Geschrieben: $datei"
    } catch {
        Write-Warning "Bereich '$name' nicht gesichert: $($_.Exception.Message)"
    }
}
