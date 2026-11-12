<#
.SYNOPSIS
    Nur-Lese-Diagnose fuer Windows-DHCP-Server und -Client (Uebung 12.1).
.DESCRIPTION
    Auf dem Server (-Rolle Server): Autorisierung, Dienststatus, Scopes mit Zustand, Statistik, Failover.
    Auf dem Client (-Rolle Client): Adresskonfiguration, DHCP-aktivierte Adapter, APIPA-Erkennung (169.254.x.x).
    Aendert nichts. Ob jede Eigenschaft in jeder Windows-Version vorhanden ist, ist nicht bestaetigt.
#>
[CmdletBinding()]
param(
    [ValidateSet('Server', 'Client')][string]$Rolle = 'Client'
)

if ($Rolle -eq 'Server') {
    Write-Host '== Dienst';          Get-Service DHCPServer | Select-Object Name, Status
    Write-Host '== Autorisierung';   Get-DhcpServerInDC -ErrorAction SilentlyContinue
    Write-Host '== Scopes';          Get-DhcpServerv4Scope | Select-Object ScopeId, Name, State, StartRange, EndRange
    Write-Host '== Statistik';       Get-DhcpServerv4ScopeStatistics | Select-Object ScopeId, PercentageInUse
    Write-Host '== Failover';        Get-DhcpServerv4Failover -ErrorAction SilentlyContinue
} else {
    Write-Host '== Adapter mit DHCP'
    Get-NetIPInterface -AddressFamily IPv4 | Where-Object Dhcp -eq 'Enabled' |
        Select-Object InterfaceAlias, Dhcp, ConnectionState
    Write-Host '== IPv4-Adressen'
    $adr = Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias, IPAddress, PrefixOrigin
    $adr
    if ($adr | Where-Object IPAddress -like '169.254.*') {
        Write-Warning 'APIPA-Adresse (169.254.x.x): Der Client hat keinen DHCP-Server erreicht.'
    }
    Write-Host '== Standardgateway und DNS'
    Get-NetIPConfiguration | Select-Object InterfaceAlias, @{n='Gateway';e={$_.IPv4DefaultGateway.NextHop}}, @{n='DNS';e={$_.DNSServer.ServerAddresses -join ','}}
}
