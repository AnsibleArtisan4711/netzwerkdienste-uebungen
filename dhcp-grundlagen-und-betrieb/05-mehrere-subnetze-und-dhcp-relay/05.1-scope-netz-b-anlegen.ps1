<#
.SYNOPSIS
    Legt den Scope "Netz-B" an (Uebung 05.1, Teil 2).
.DESCRIPTION
    Bereich 192.168.20.100-199, Maske 255.255.255.0, Lease-Dauer 8 Stunden, aktiviert.
    Scope-Optionen: Router 192.168.20.1, DNS-Server 192.168.10.10, Domaene corp.example.com.
    Existiert der Scope schon, wird er nicht neu angelegt. Muss als Administrator auf SRV-WIN-DHCP1 laufen.
    Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param()

$scopeId = '192.168.20.0'
if (-not (Get-DhcpServerv4Scope -ScopeId $scopeId -ErrorAction SilentlyContinue)) {
    if ($PSCmdlet.ShouldProcess($scopeId, 'Scope Netz-B anlegen')) {
        Add-DhcpServerv4Scope -Name 'Netz-B' -StartRange 192.168.20.100 -EndRange 192.168.20.199 `
            -SubnetMask 255.255.255.0 -LeaseDuration (New-TimeSpan -Hours 8) -State Active
    }
} else {
    Write-Host "Scope $scopeId existiert bereits."
}
if ($PSCmdlet.ShouldProcess($scopeId, 'Scope-Optionen setzen')) {
    Set-DhcpServerv4OptionValue -ScopeId $scopeId -Router 192.168.20.1 -DnsServer 192.168.10.10 -DnsDomain corp.example.com
}
Get-DhcpServerv4Scope | Select-Object Name, ScopeId, StartRange, EndRange, State
