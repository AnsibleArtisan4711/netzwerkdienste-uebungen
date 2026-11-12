<#
.SYNOPSIS
    Liest die letzten Zeilen des DHCP-Audit-Logs (Uebung 10.1, Teil 2).
.DESCRIPTION
    Get-DhcpServerAuditLog liefert nur die EINSTELLUNGEN (Pfad, Aktivierung, Groesse), nicht den Inhalt.
    Das Skript liest den Pfad aus den Einstellungen und zeigt die letzten Zeilen der juengsten Logdatei.
    Der Dateiname (Muster DhcpSrvLog-*.log) ist nicht bestaetigt; das Skript nimmt die zuletzt geaenderte Datei.
    Nur lesend. Auf dem DHCP-Server ausfuehren.
#>
[CmdletBinding()]
param(
    [int]$Zeilen = 30
)

$einst = Get-DhcpServerAuditLog
$einst | Format-List
$datei = Get-ChildItem -Path $einst.Path -Filter '*.log' -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $datei) { Write-Warning "Keine Logdatei in $($einst.Path) gefunden."; return }
Write-Host "Datei: $($datei.FullName)"
Get-Content -Path $datei.FullName -Tail $Zeilen
