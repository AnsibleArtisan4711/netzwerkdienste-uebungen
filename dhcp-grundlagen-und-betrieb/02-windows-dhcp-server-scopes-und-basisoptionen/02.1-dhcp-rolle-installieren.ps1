<#
.SYNOPSIS
    Installiert die DHCP-Server-Rolle samt Verwaltungstools (Uebung 02.1, Teil 1).
.DESCRIPTION
    Installiert die Rolle DHCP, legt die lokalen Sicherheitsgruppen "DHCP Administrators" und
    "DHCP Users" an (netsh dhcp add securitygroups), startet den Dienst DHCPServer neu und zeigt
    Dienststatus und Bindungen an. Muss als Administrator auf SRV-WIN-DHCP1 laufen.
    Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param()

if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Rolle DHCP installieren')) {
    Install-WindowsFeature -Name DHCP -IncludeManagementTools
}
if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Sicherheitsgruppen anlegen und Dienst neu starten')) {
    netsh dhcp add securitygroups
    Restart-Service -Name DHCPServer
}
if (Get-Service -Name DHCPServer -ErrorAction SilentlyContinue) {
    Get-Service -Name DHCPServer | Select-Object Name, Status, StartType
    Get-DhcpServerv4Binding
}
