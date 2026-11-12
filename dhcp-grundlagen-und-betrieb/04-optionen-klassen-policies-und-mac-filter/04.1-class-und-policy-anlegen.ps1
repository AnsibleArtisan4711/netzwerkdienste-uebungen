<#
.SYNOPSIS
    Legt User-Class "Labor" und Policy "Labor-Clients" im Scope Netz-A an (Uebung 04.1, Teil 2).
.DESCRIPTION
    Class: Typ User, Daten "Labor". Policy: Bedingung UserClass EQ Labor, Lease-Dauer 1 Stunde,
    abweichender Domaenenname labor.corp.example.com. Vorhandene Objekte werden nicht doppelt angelegt.
    Die Reservierung muss vorher entfernt sein (siehe Uebung). Rueckbau: 04.1-rueckbau.ps1.
    Muss als Administrator auf SRV-WIN-DHCP1 laufen. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param([string]$ScopeId = '192.168.10.0')

if (-not (Get-DhcpServerv4Class -Name 'Labor' -ErrorAction SilentlyContinue)) {
    if ($PSCmdlet.ShouldProcess('Server', 'User-Class Labor anlegen')) {
        Add-DhcpServerv4Class -Name 'Labor' -Type User -Data 'Labor' -Description 'Laborrechner Modul 4'
    }
}
if (-not (Get-DhcpServerv4Policy -ScopeId $ScopeId -Name 'Labor-Clients' -ErrorAction SilentlyContinue)) {
    if ($PSCmdlet.ShouldProcess($ScopeId, 'Policy Labor-Clients anlegen')) {
        Add-DhcpServerv4Policy -Name 'Labor-Clients' -ScopeId $ScopeId -Condition OR `
            -UserClass EQ,Labor -LeaseDuration (New-TimeSpan -Hours 1)
        Set-DhcpServerv4OptionValue -ScopeId $ScopeId -PolicyName 'Labor-Clients' -DnsDomain 'labor.corp.example.com'
    }
}
Get-DhcpServerv4Class -ErrorAction SilentlyContinue
Get-DhcpServerv4Policy -ScopeId $ScopeId -ErrorAction SilentlyContinue
