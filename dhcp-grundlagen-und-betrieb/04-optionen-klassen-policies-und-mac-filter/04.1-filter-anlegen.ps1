<#
.SYNOPSIS
    Traegt eine MAC-Adresse in die Deny-Liste ein und aktiviert sie (Uebung 04.1, Teil 3).
.DESCRIPTION
    ACHTUNG: Die Deny-Liste wirkt serverweit. Rueckbau mit 04.1-rueckbau.ps1.
    Syntax von Add-DhcpServerv4Filter und die MAC-Schreibweise sind nicht bestaetigt.
    Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^([0-9A-Fa-f]{2}-){5}[0-9A-Fa-f]{2}$')]
    [string]$ClientId
)

if ($PSCmdlet.ShouldProcess($ClientId, 'In Deny-Liste eintragen und Deny-Liste aktivieren')) {
    Add-DhcpServerv4Filter -List Deny -MacAddress $ClientId -Description 'Test Modul 4'
    Set-DhcpServerv4FilterList -Deny $true
}
Get-DhcpServerv4FilterList
Get-DhcpServerv4Filter -ErrorAction SilentlyContinue
