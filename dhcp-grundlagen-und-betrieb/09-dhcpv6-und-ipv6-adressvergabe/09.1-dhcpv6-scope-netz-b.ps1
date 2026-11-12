<#
.SYNOPSIS
    Legt den DHCPv6-Scope fuer Netz B (fd00:20::/64) mit DNS-Server an (Uebung 09.1, Teil 3).
.DESCRIPTION
    Add-DhcpServerv6Scope: Praefix, Name, Lebenszeiten. Optionen per Set-DhcpServerv6OptionValue.
    Zeitwerte: Preferred 3 Stunden, Valid 4 Stunden, T1 1 Stunde, T2 2 Stunden (Laborwerte).
    Auf SRV-WIN-DHCP1 als Administrator ausfuehren. Mit -WhatIf wird nichts geaendert.
    Nicht auf Windows ausgefuehrt; Parameter gegen Microsoft Learn geprueft.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Prefix = 'fd00:20::',
    [string]$Dns    = 'fd00:10::10',
    [string]$Suche  = 'corp.example.com'
)

if (-not (Get-DhcpServerv6Scope -Prefix $Prefix -ErrorAction SilentlyContinue)) {
    if ($PSCmdlet.ShouldProcess($Prefix, 'DHCPv6-Scope anlegen')) {
        Add-DhcpServerv6Scope -Prefix $Prefix -Name 'Netz-B-v6' -State Active `
            -PreferredLifetime (New-TimeSpan -Hours 3) -ValidLifeTime (New-TimeSpan -Hours 4) `
            -T1 (New-TimeSpan -Hours 1) -T2 (New-TimeSpan -Hours 2)
    }
} else {
    Write-Host "Scope $Prefix existiert bereits."
}
if ($PSCmdlet.ShouldProcess($Prefix, 'Optionen setzen')) {
    Set-DhcpServerv6OptionValue -Prefix $Prefix -DnsServer $Dns -DomainSearchList $Suche -Force
}
Get-DhcpServerv6Scope -Prefix $Prefix -ErrorAction SilentlyContinue
Get-DhcpServerv6OptionValue -Prefix $Prefix -ErrorAction SilentlyContinue
