<#
.SYNOPSIS
    Fuegt SRV-WIN-DNS bzw. CLI-TEST-01 die zweite Adresse im Netz 192.168.60.0/24 hinzu (Uebung 09.1, Teil 1).
.DESCRIPTION
    Legt auf der angegebenen Netzwerkkarte eine zusaetzliche IPv4-Adresse an (New-NetIPAddress, ohne Gateway).
    Auf SRV-WIN-DNS muss die Adresse danach zu den Lauschadressen des DNS-Servers hinzugefuegt werden
    (siehe Aufgabentext; der Parametername von Set-DnsServerSetting ist nicht bestaetigt).
    Als Administrator ausfuehren. Mit -WhatIf wird nichts geaendert.
.EXAMPLE
    .\09.1-windows-zweites-subnetz.ps1 -InterfaceAlias Ethernet -IPAddress 192.168.60.10 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][string]$InterfaceAlias,
    [Parameter(Mandatory)][ValidatePattern('^192\.168\.60\.\d{1,3}$')][string]$IPAddress,
    [int]$PrefixLength = 24
)

if (Get-NetIPAddress -IPAddress $IPAddress -ErrorAction SilentlyContinue) {
    Write-Host "Adresse $IPAddress ist bereits vorhanden."
}
elseif ($PSCmdlet.ShouldProcess($InterfaceAlias, "Adresse $IPAddress/$PrefixLength hinzufuegen")) {
    New-NetIPAddress -InterfaceAlias $InterfaceAlias -IPAddress $IPAddress -PrefixLength $PrefixLength
}
if (-not $WhatIfPreference) {
    Get-NetIPAddress -InterfaceAlias $InterfaceAlias -AddressFamily IPv4 | Format-Table IPAddress, PrefixLength -AutoSize
}
