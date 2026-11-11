<#
.SYNOPSIS
    Loest auf CLI-TEST-01 die dynamische Registrierung aus und prueft den Eintrag (Uebung 08.1, Teil 2).
.DESCRIPTION
    Entspricht "ipconfig /registerdns": Register-DnsClient meldet Namen und Adressen des Clients beim DNS-Server an.
    Danach wird der A-Eintrag des Clients bei SRV-WIN-DNS abgefragt. Aendert nur die Registrierung des Clients.
    Voraussetzung: Der Client verwendet 192.168.50.10 als DNS-Server (Set-DnsClientServerAddress).
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Server = '192.168.50.10',
    [string]$Domaene = 'corp.example.com'
)

if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Dynamische Registrierung ausloesen')) {
    Register-DnsClient
    Start-Sleep -Seconds 5
}
$fqdn = "$($env:COMPUTERNAME).$Domaene"
Write-Host "== Abfrage $fqdn bei $Server"
Resolve-DnsName -Name $fqdn -Type A -Server $Server -DnsOnly -ErrorAction SilentlyContinue |
    Format-Table Name, Type, TTL, IPAddress -AutoSize
