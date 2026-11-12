<#
.SYNOPSIS
    Richtet DHCP-Failover fuer den Scope Netz-B ein (Uebung 07.1, Teil 2).
.DESCRIPTION
    Modus Lastverteilung (50:50) oder HotStandby (SRV-WIN-DHCP1 aktiv, 10 % Reserve).
    Das gemeinsame Geheimnis wird interaktiv abgefragt und nirgends gespeichert.
    Auf SRV-WIN-DHCP1 als Administrator ausfuehren. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [ValidateSet('Lastverteilung', 'HotStandby')]
    [string]$Modus = 'Lastverteilung',
    [string]$Name = 'FO-Netz-B',
    [string]$ScopeId = '192.168.20.0',
    [string]$Partner = 'SRV-WIN-DHCP2.corp.example.com'
)

if ($PSCmdlet.ShouldProcess("$Name ($Modus)", 'Failover einrichten')) {
    $geheimnis = Read-Host 'Gemeinsames Geheimnis fuer den Failover'
    $gemeinsam = @{
        Name = $Name; ScopeId = $ScopeId; PartnerServer = $Partner
        MaxClientLeadTime = (New-TimeSpan -Hours 1); SharedSecret = $geheimnis
    }
    if ($Modus -eq 'Lastverteilung') {
        Add-DhcpServerv4Failover @gemeinsam -LoadBalancePercent 50 `
            -AutoStateTransition $true -StateSwitchInterval (New-TimeSpan -Minutes 30)
    } else {
        Add-DhcpServerv4Failover @gemeinsam -ServerRole Active -ReservePercent 10
    }
}
Get-DhcpServerv4Failover -Name $Name -ErrorAction SilentlyContinue
