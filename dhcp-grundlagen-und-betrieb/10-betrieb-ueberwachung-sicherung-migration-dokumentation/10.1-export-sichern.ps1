<#
.SYNOPSIS
    Exportiert Konfiguration und Leases des DHCP-Servers in eine XML-Datei (Uebung 10.1, Teil 3).
.DESCRIPTION
    Export-DhcpServer -File ... -Leases. Zielordner wird bei Bedarf angelegt, der Dateiname enthaelt den Zeitstempel.
    Die Datei enthaelt Konfiguration und Leases, aber keine Kennwoerter; trotzdem an einem geschuetzten Ort ablegen.
    Auf dem DHCP-Server als Administrator ausfuehren. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Ordner = 'C:\DhcpSicherung'
)

$datei = Join-Path $Ordner ('dhcp-export-{0:yyyyMMdd-HHmmss}.xml' -f (Get-Date))
if ($PSCmdlet.ShouldProcess($datei, 'DHCP-Server exportieren')) {
    if (-not (Test-Path $Ordner)) { New-Item -ItemType Directory -Path $Ordner | Out-Null }
    Export-DhcpServer -File $datei -Leases
    Write-Host "Export: $datei"
}
