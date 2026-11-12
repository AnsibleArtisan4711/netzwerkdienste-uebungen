<#
.SYNOPSIS
    Autorisiert SRV-WIN-DHCP1 in Active Directory und richtet die DNS-Registrierung fuer Netz-B ein (Uebung 06.1, Teile 2 und 3).
.DESCRIPTION
    1. Autorisierung des Servers (Add-DhcpServerInDC), nur wenn noch nicht eingetragen.
    2. DNS-Dienstkonto hinterlegen (Set-DhcpServerDnsCredential); Benutzername und Kennwort
       werden vom Cmdlet interaktiv abgefragt und nirgends gespeichert.
    3. DNS-Einstellung fuer den Scope Netz-B: Always, aeltere Clients, Loeschen bei Ablauf, Name Protection.
    Als Domaenenadministrator auf SRV-WIN-DHCP1 ausfuehren. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$DnsName   = 'SRV-WIN-DHCP1.corp.example.com',
    [string]$Adresse   = '192.168.10.11',
    [string]$ScopeId   = '192.168.20.0',
    [string]$Konto     = 'CORP\svc-dhcp-dns'
)

$eingetragen = Get-DhcpServerInDC -ErrorAction SilentlyContinue | Where-Object { $_.IPAddress -eq $Adresse }
if (-not $eingetragen) {
    if ($PSCmdlet.ShouldProcess($DnsName, 'In Active Directory autorisieren')) {
        Add-DhcpServerInDC -DnsName $DnsName -IPAddress $Adresse
    }
} else {
    Write-Host 'Server ist bereits autorisiert.'
}

if ($PSCmdlet.ShouldProcess($Konto, 'DNS-Dienstkonto hinterlegen')) {
    Set-DhcpServerDnsCredential -Credential (Get-Credential -UserName $Konto -Message 'Kennwort des DNS-Dienstkontos')
}

if ($PSCmdlet.ShouldProcess($ScopeId, 'DNS-Einstellung setzen')) {
    Set-DhcpServerv4DnsSetting -ScopeId $ScopeId -DynamicUpdates Always `
        -UpdateDnsRRForOlderClients $true -DeleteDnsRROnLeaseExpiry $true -NameProtection $true
}
Get-DhcpServerInDC -ErrorAction SilentlyContinue
Get-DhcpServerv4DnsSetting -ScopeId $ScopeId -ErrorAction SilentlyContinue
