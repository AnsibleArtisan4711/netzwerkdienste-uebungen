<#
.SYNOPSIS
    Baut auf SRV-WIN-DC1 die Gesamtstruktur corp.example.com mit DNS auf (Uebung 06.1, Teil 1).
.DESCRIPTION
    Installiert AD DS und DNS, fragt das DSRM-Kennwort interaktiv ab (wird nirgends gespeichert)
    und stuft den Server zum Domaenencontroller herauf. Danach Neustart.
    Nur auf SRV-WIN-DC1 im Labor ausfuehren. Vorher Checkpoint anlegen. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Domaene = 'corp.example.com',
    [string]$Netbios = 'CORP'
)

if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'AD DS und DNS installieren')) {
    Install-WindowsFeature -Name AD-Domain-Services, DNS -IncludeManagementTools
}
if ($PSCmdlet.ShouldProcess($Domaene, 'Gesamtstruktur anlegen und Server neu starten')) {
    $dsrm = Read-Host 'Kennwort fuer den Wiederherstellungsmodus (DSRM)' -AsSecureString
    Install-ADDSForest -DomainName $Domaene -DomainNetbiosName $Netbios `
        -InstallDns -SafeModeAdministratorPassword $dsrm
}
