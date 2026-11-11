<#
.SYNOPSIS
    Bereitet SRV-WIN-DNS auf die Heraufstufung zum Domaenencontroller vor (Uebung 08.1, Teil 2).
.DESCRIPTION
    - Prueft, dass corp.example.com eine dateibasierte primaere Zone ist.
    - Erlaubt voruebergehend dynamische Updates (NonsecureAndSecure), damit sich der Domaenencontroller nach der
      Heraufstufung mit seinen SRV-Eintraegen eintragen kann (Install-ADDSForest -InstallDns:$false legt keine Zone an).
      Nach der Umwandlung in eine AD-integrierte Zone setzt 08.1-windows-ad-zonen-umwandeln.ps1 auf Secure.
    - Zeigt an, welche DNS-Server die Netzwerkkarten verwenden (der Server soll sich selbst abfragen).
    Das Skript startet die Heraufstufung NICHT und fragt kein Kennwort ab. Als Administrator ausfuehren. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Zone = 'corp.example.com'
)

$z = Get-DnsServerZone -Name $Zone -ErrorAction SilentlyContinue
if (-not $z) { throw "Zone $Zone nicht gefunden." }
if ($z.IsDsIntegrated) { Write-Warning "Zone $Zone ist bereits AD-integriert; dieser Schritt ist nicht noetig." }
else {
    if ($PSCmdlet.ShouldProcess($Zone, 'Dynamische Updates auf NonsecureAndSecure setzen (nur bis zur Umwandlung)')) {
        Set-DnsServerPrimaryZone -Name $Zone -DynamicUpdate NonsecureAndSecure
        Write-Host "Zone ${Zone}: dynamische Updates erlaubt (vorlaeufig)."
    }
}

Write-Host "`n== DNS-Server der Netzwerkkarten (sollte 192.168.50.10 bzw. 127.0.0.1 enthalten)"
Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object { $_.ServerAddresses } |
    Format-Table InterfaceAlias, ServerAddresses -AutoSize

Write-Host '== Naechster Schritt (Kennwort fuer den Verzeichnisdienst-Wiederherstellungsmodus gibst DU ein):'
Write-Host '   Install-WindowsFeature AD-Domain-Services -IncludeManagementTools'
Write-Host '   Test-ADDSForestInstallation -DomainName corp.example.com -InstallDns:$false'
Write-Host '   Install-ADDSForest -DomainName corp.example.com -InstallDns:$false'
