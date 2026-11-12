<#
.SYNOPSIS
    Legt eine DHCP-Reservierung im Scope Netz-A an (Uebung 03.1, Teil 2).
.DESCRIPTION
    Standard: 192.168.10.150. Die MAC-Adresse muss angegeben werden (Schreibweise 00-15-5D-xx-xx-xx).
    Existiert die Reservierung schon, wird nichts geaendert. Muss als Administrator auf SRV-WIN-DHCP1
    laufen. Mit -WhatIf wird nichts geaendert.
.EXAMPLE
    .\03.1-reservierung-anlegen.ps1 -ClientId 00-15-5D-01-02-03 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^([0-9A-Fa-f]{2}-){5}[0-9A-Fa-f]{2}$')]
    [string]$ClientId,
    [string]$ScopeId   = '192.168.10.0',
    [string]$IPAddress = '192.168.10.150',
    [string]$Name      = 'CLI-WIN-A'
)

$vorhanden = Get-DhcpServerv4Reservation -ScopeId $ScopeId -ErrorAction SilentlyContinue |
    Where-Object { $_.IPAddress.IPAddressToString -eq $IPAddress }
if ($vorhanden) {
    Write-Host "Reservierung fuer $IPAddress existiert bereits."
} elseif ($PSCmdlet.ShouldProcess("$ScopeId / $IPAddress", "Reservierung fuer $ClientId anlegen")) {
    Add-DhcpServerv4Reservation -ScopeId $ScopeId -IPAddress $IPAddress -ClientId $ClientId `
        -Name $Name -Description 'Reservierung Modul 3'
}
Get-DhcpServerv4Reservation -ScopeId $ScopeId -ErrorAction SilentlyContinue
