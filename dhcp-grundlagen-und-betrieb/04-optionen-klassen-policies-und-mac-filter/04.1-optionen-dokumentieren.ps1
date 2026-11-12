<#
.SYNOPSIS
    Schreibt Scopes, Optionen, Reservierungen und Ausschluesse in eine Textdatei (Uebung 04.1, Teil 4).
.DESCRIPTION
    Aendert nichts am Server. Standardpfad C:\Uebung\dhcp-optionen.txt; das Verzeichnis wird bei Bedarf angelegt.
#>
[CmdletBinding()]
param([string]$Pfad = 'C:\Uebung\dhcp-optionen.txt')

$ordner = Split-Path -Parent $Pfad
if (-not (Test-Path $ordner)) { New-Item -ItemType Directory -Path $ordner | Out-Null }

$zeilen = New-Object System.Collections.Generic.List[string]
$zeilen.Add("DHCP-Dokumentation, erzeugt am $(Get-Date -Format 'yyyy-MM-dd HH:mm') auf $env:COMPUTERNAME")
$zeilen.Add('')
$zeilen.Add('== Serveroptionen ==')
(Get-DhcpServerv4OptionValue -ErrorAction SilentlyContinue | Format-Table -AutoSize | Out-String) -split "`r?`n" | ForEach-Object { $zeilen.Add($_) }
foreach ($scope in Get-DhcpServerv4Scope) {
    $zeilen.Add("== Scope $($scope.Name) ($($scope.ScopeId)) ==")
    $zeilen.Add(($scope | Select-Object StartRange, EndRange, SubnetMask, State, LeaseDuration | Format-List | Out-String))
    $zeilen.Add('-- Scope-Optionen --')
    $zeilen.Add((Get-DhcpServerv4OptionValue -ScopeId $scope.ScopeId -ErrorAction SilentlyContinue | Format-Table -AutoSize | Out-String))
    $zeilen.Add('-- Reservierungen --')
    $zeilen.Add((Get-DhcpServerv4Reservation -ScopeId $scope.ScopeId -ErrorAction SilentlyContinue | Format-Table -AutoSize | Out-String))
    $zeilen.Add('-- Ausschluesse --')
    $zeilen.Add((Get-DhcpServerv4ExclusionRange -ScopeId $scope.ScopeId -ErrorAction SilentlyContinue | Format-Table -AutoSize | Out-String))
}
$zeilen | Set-Content -Path $Pfad -Encoding UTF8
Write-Host "Geschrieben: $Pfad"
