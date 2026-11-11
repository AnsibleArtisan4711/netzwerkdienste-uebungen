<#
.SYNOPSIS
    Wandelt die Zonen corp.example.com und 50.168.192.in-addr.arpa in AD-integrierte Zonen um (Uebung 08.1, Teil 2).
.DESCRIPTION
    Voraussetzung: SRV-WIN-DNS ist bereits Domaenencontroller (nach Install-ADDSForest und Neustart).
    Je Zone:
      1. ConvertTo-DnsServerPrimaryZone -ReplicationScope Domain   (Replikationsbereich: DomainDnsZones)
      2. Set-DnsServerPrimaryZone -DynamicUpdate Secure            (nur sichere dynamische Updates)
      3. Zonenuebertragung und NOTIFY fuer SRV-LIN-BIND (192.168.50.11) erneut setzen, damit BIND Sekundaerserver bleibt
    Als Administrator ausfuehren. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string[]]$Zonen = @('corp.example.com', '50.168.192.in-addr.arpa'),
    [ValidateSet('Domain', 'Forest')]
    [string]$Bereich = 'Domain',
    [string]$BindServer = '192.168.50.11'
)

foreach ($name in $Zonen) {
    $z = Get-DnsServerZone -Name $name -ErrorAction SilentlyContinue
    if (-not $z) { Write-Warning "Zone $name nicht gefunden - uebersprungen."; continue }

    if ($z.IsDsIntegrated) {
        Write-Host "Zone $name ist bereits AD-integriert."
    } elseif ($PSCmdlet.ShouldProcess($name, "In AD-integrierte Zone umwandeln (Bereich $Bereich)")) {
        ConvertTo-DnsServerPrimaryZone -Name $name -ReplicationScope $Bereich -Force
        Write-Host "Zone $name umgewandelt."
    }

    if ($PSCmdlet.ShouldProcess($name, 'Nur sichere dynamische Updates')) {
        Set-DnsServerPrimaryZone -Name $name -DynamicUpdate Secure
    }
    if ($PSCmdlet.ShouldProcess($name, "Zonenuebertragung und NOTIFY fuer $BindServer setzen")) {
        Set-DnsServerPrimaryZone -Name $name -SecureSecondaries TransferToSecureServers -SecondaryServers $BindServer -Notify NotifyServers -NotifyServers $BindServer
    }
}

if (-not $WhatIfPreference) {
    Write-Host "`n== Ergebnis"
    Get-DnsServerZone | Where-Object { $_.ZoneName -in $Zonen } |
        Format-Table ZoneName, ZoneType, IsDsIntegrated, DynamicUpdate, ReplicationScope -AutoSize
}
