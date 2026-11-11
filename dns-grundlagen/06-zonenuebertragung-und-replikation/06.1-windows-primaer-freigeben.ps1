<#
.SYNOPSIS
    Gibt auf SRV-WIN-DNS die Zonenuebertragung nur an SRV-LIN-BIND frei (Uebung 06.1, Teil 1).
.DESCRIPTION
    Fuer corp.example.com und die beiden Reverse-Zonen aus Uebung 05.1:
    - NS-Eintrag fuer linserver.branch.example.org am Zonenursprung (falls noch nicht vorhanden),
    - Zonenuebertragung ausschliesslich an die angegebene Adresse (-SecureSecondaries TransferToSecureServers
      zusammen mit -SecondaryServers, wie im Beispiel in Microsoft Learn),
    - Benachrichtigung (NOTIFY) an dieselbe Adresse (-Notify NotifyServers -NotifyServers).
    Fuer den NS-Eintrag am Zonenursprung wird der Name "@" verwendet; das ist NICHT bestaetigt.
    Falls Windows "@" ablehnt, mit -ApexName '.' aufrufen.
    Der Eigenschaftsname RecordData.NameServer zum Erkennen vorhandener NS-Eintraege stammt aus meinem Wissen (NICHT bestaetigt).
    Als Administrator auf SRV-WIN-DNS ausfuehren. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Sekundaer   = '192.168.50.11',
    [string]$NameServer  = 'linserver.branch.example.org',
    [string]$ApexName    = '@',
    [string[]]$Zonen     = @('corp.example.com', '50.168.192.in-addr.arpa', '0.0.0.0.0.0.0.0.0.5.0.0.0.0.d.f.ip6.arpa')
)

foreach ($zone in $Zonen) {
    if (-not (Get-DnsServerZone -Name $zone -ErrorAction SilentlyContinue)) {
        Write-Warning "Zone $zone existiert nicht (Uebung 04.1 und 05.1 zuerst durchfuehren). Uebersprungen."
        continue
    }

    # 1. NS-Eintrag fuer den Sekundaerserver
    $ns = Get-DnsServerResourceRecord -ZoneName $zone -RRType NS -ErrorAction SilentlyContinue |
          Where-Object { $_.RecordData.NameServer -like "$NameServer*" }
    if ($ns) {
        Write-Host "vorhanden  NS  $NameServer in $zone"
    } elseif ($PSCmdlet.ShouldProcess($zone, "NS-Eintrag $NameServer anlegen")) {
        Add-DnsServerResourceRecord -ZoneName $zone -NS -Name $ApexName -NameServer $NameServer
        Write-Host "angelegt   NS  $NameServer in $zone"
    }

    # 2. Transfer nur an $Sekundaer, NOTIFY nur an $Sekundaer
    if ($PSCmdlet.ShouldProcess($zone, "Transfer und NOTIFY nur an $Sekundaer")) {
        Set-DnsServerPrimaryZone -Name $zone -SecureSecondaries TransferToSecureServers -SecondaryServers $Sekundaer `
                                 -Notify NotifyServers -NotifyServers $Sekundaer
        Write-Host "gesetzt    Transfer/NOTIFY nur an $Sekundaer in $zone"
    }
}

if (-not $WhatIfPreference) {
    Get-DnsServerZone | Where-Object { $_.ZoneName -in $Zonen } |
        Select-Object ZoneName, ZoneType, SecureSecondaries, Notify, @{ n = 'Sekundaerserver'; e = { $_.SecondaryServers -join ',' } } |
        Format-Table -AutoSize
}
