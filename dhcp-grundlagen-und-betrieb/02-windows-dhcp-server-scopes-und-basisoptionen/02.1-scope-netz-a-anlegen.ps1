<#
.SYNOPSIS
    Legt den Scope "Netz-A" mit Router, DNS-Server und Domaenenname an (Uebung 02.1, Teil 2).
.DESCRIPTION
    Bereich 192.168.10.100-199, Maske 255.255.255.0, Lease-Dauer 8 Stunden, aktiviert.
    Optionen auf Scope-Ebene: Router 192.168.10.1, DNS-Server 192.168.10.10, Domaene corp.example.com.
    Existiert der Scope schon, wird er nicht neu angelegt; die Optionen werden trotzdem gesetzt.
    Muss als Administrator auf SRV-WIN-DHCP1 laufen. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$ScopeId = '192.168.10.0',
    [string]$Start   = '192.168.10.100',
    [string]$Ende    = '192.168.10.199',
    [string]$Router  = '192.168.10.1',
    [string]$Dns     = '192.168.10.10',
    [string]$Domaene = 'corp.example.com'
)

$vorhanden = Get-DhcpServerv4Scope -ScopeId $ScopeId -ErrorAction SilentlyContinue
if (-not $vorhanden) {
    if ($PSCmdlet.ShouldProcess($ScopeId, 'Scope Netz-A anlegen')) {
        Add-DhcpServerv4Scope -Name 'Netz-A' -StartRange $Start -EndRange $Ende `
            -SubnetMask 255.255.255.0 -LeaseDuration (New-TimeSpan -Hours 8) -State Active
    }
} else {
    Write-Host "Scope $ScopeId existiert bereits."
}
if ($PSCmdlet.ShouldProcess($ScopeId, 'Scope-Optionen setzen')) {
    Set-DhcpServerv4OptionValue -ScopeId $ScopeId -Router $Router -DnsServer $Dns -DnsDomain $Domaene
}
Get-DhcpServerv4Scope -ScopeId $ScopeId -ErrorAction SilentlyContinue |
    Select-Object Name, ScopeId, StartRange, EndRange, State, LeaseDuration
Get-DhcpServerv4OptionValue -ScopeId $ScopeId -ErrorAction SilentlyContinue
