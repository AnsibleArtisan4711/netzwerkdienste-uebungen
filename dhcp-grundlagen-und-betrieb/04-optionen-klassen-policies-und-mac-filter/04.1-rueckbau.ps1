<#
.SYNOPSIS
    Nimmt alle Aenderungen von Uebung 04.1 zurueck (Filter, Policy, Class) und stellt die Reservierung wieder her.
.DESCRIPTION
    Schritte: Deny-Liste deaktivieren, Filter fuer die MAC-Adresse entfernen, Policy Labor-Clients entfernen,
    Class Labor entfernen, Reservierung 192.168.10.150 neu anlegen. Fehlende Objekte werden uebersprungen.
    Auf CLI-WIN-A zusaetzlich: ipconfig /setclassid "Ethernet"   (leert die Class-ID).
    Muss als Administrator auf SRV-WIN-DHCP1 laufen. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^([0-9A-Fa-f]{2}-){5}[0-9A-Fa-f]{2}$')]
    [string]$ClientId,
    [string]$ScopeId = '192.168.10.0',
    [string]$ReservierteAdresse = '192.168.10.150'
)

if ($PSCmdlet.ShouldProcess('Server', 'Deny-Liste deaktivieren')) {
    Set-DhcpServerv4FilterList -Deny $false -Allow $false
}
if ($PSCmdlet.ShouldProcess($ClientId, 'Filtereintrag entfernen')) {
    Remove-DhcpServerv4Filter -MacAddress $ClientId -ErrorAction SilentlyContinue
}
if (Get-DhcpServerv4Policy -ScopeId $ScopeId -Name 'Labor-Clients' -ErrorAction SilentlyContinue) {
    if ($PSCmdlet.ShouldProcess('Labor-Clients', 'Policy entfernen')) {
        Remove-DhcpServerv4Policy -ScopeId $ScopeId -Name 'Labor-Clients'
    }
}
if (Get-DhcpServerv4Class -Name 'Labor' -ErrorAction SilentlyContinue) {
    if ($PSCmdlet.ShouldProcess('Labor', 'User-Class entfernen')) {
        Remove-DhcpServerv4Class -Name 'Labor'
    }
}
$res = Get-DhcpServerv4Reservation -ScopeId $ScopeId -ErrorAction SilentlyContinue |
    Where-Object { $_.IPAddress.IPAddressToString -eq $ReservierteAdresse }
if (-not $res) {
    if ($PSCmdlet.ShouldProcess($ReservierteAdresse, 'Reservierung neu anlegen')) {
        Add-DhcpServerv4Reservation -ScopeId $ScopeId -IPAddress $ReservierteAdresse -ClientId $ClientId -Name 'CLI-WIN-A'
    }
}
Write-Host 'Auf CLI-WIN-A: ipconfig /setclassid "Ethernet"  und  ipconfig /renew'
Get-DhcpServerv4FilterList
