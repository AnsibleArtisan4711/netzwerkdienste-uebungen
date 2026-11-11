<#
.SYNOPSIS
    Richtet auf SRV-WIN-DNS den Windows-Teil des Abschlussprojekts AlpenTech ein (Uebung 12.1, Teil 2).
.DESCRIPTION
    1. Primaere Zone hq.alpentech.internal (Datei, keine dynamischen Updates).
    2. Eintraege: A und AAAA (ns1, fs01, mail, erp), CNAME (intranet), MX, TXT, SRV, NS fuer den Partner.
    3. PTR-Eintraege fuer fs01, mail, erp, git, ci, build in den vorhandenen Reverse-Zonen (IPv4 und IPv6).
    4. Transfer und NOTIFY der Zone hq nur an den Partner (SRV-LIN-BIND).
    5. Sekundaere Zone dev.alpentech.internal mit Primaerserver SRV-LIN-BIND, sofortiger Transfer.
    Bereits vorhandene Eintraege gleichen Namens und Typs werden uebersprungen (geprueft wird nur Name und Typ).
    Voraussetzungen: Reverse-Zonen aus Uebung 05.1, Transferfreigabe der Reverse-Zonen aus 06.1,
    auf SRV-LIN-BIND ist dev.alpentech.internal angelegt und fuer 192.168.50.10 freigegeben (12.1-named.conf.local-ergaenzung).
    NICHT bestaetigt: Name "@" fuer Eintraege am Zonenursprung (sonst -ApexName '.' angeben).
    NICHT erledigt: Transferbeschraenkung der sekundaeren Zone dev (Set-DnsServerSecondaryZone kennt keinen Parameter dafuer),
    siehe Hinweis am Ende der Ausgabe. Als Administrator ausfuehren. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Partner  = '192.168.50.11',
    [string]$ApexName = '@'
)

$zone = 'hq.alpentech.internal'
$dev  = 'dev.alpentech.internal'
$rev4 = '50.168.192.in-addr.arpa'
$rev6 = '0.0.0.0.0.0.0.0.0.5.0.0.0.0.d.f.ip6.arpa'

function Neu {
    param([string]$ZoneName, [string]$Name, [string]$Typ, [string]$Text, [scriptblock]$Aktion)
    $vorhanden = Get-DnsServerResourceRecord -ZoneName $ZoneName -Name $Name -RRType $Typ -ErrorAction SilentlyContinue
    if ($vorhanden) { Write-Host "vorhanden  $Typ  $Name in $ZoneName"; return }
    if ($PSCmdlet.ShouldProcess("$Name in $ZoneName ($Typ)", "Anlegen: $Text")) {
        & $Aktion
        Write-Host "angelegt   $Typ  $Name in $ZoneName  ($Text)"
    }
}

# 1. Zone
if (Get-DnsServerZone -Name $zone -ErrorAction SilentlyContinue) {
    Write-Host "Zone $zone existiert bereits."
} elseif ($PSCmdlet.ShouldProcess($zone, 'Primaere Zone anlegen')) {
    Add-DnsServerPrimaryZone -Name $zone -ZoneFile "$zone.dns" -DynamicUpdate None
    Write-Host "Zone $zone angelegt."
}

# 2. Eintraege der Zone hq
$hosts = @(
    @{ n = 'ns1';  v4 = '192.168.50.10'; v6 = 'fd00:50::10' },
    @{ n = 'fs01'; v4 = '192.168.50.51'; v6 = 'fd00:50::51' },
    @{ n = 'mail'; v4 = '192.168.50.52'; v6 = 'fd00:50::52' },
    @{ n = 'erp';  v4 = '192.168.50.53'; v6 = 'fd00:50::53' }
)
foreach ($h in $hosts) {
    Neu $zone $h.n 'A'    $h.v4 { Add-DnsServerResourceRecord -ZoneName $zone -A    -Name $h.n -IPv4Address $h.v4 }
    Neu $zone $h.n 'AAAA' $h.v6 { Add-DnsServerResourceRecord -ZoneName $zone -AAAA -Name $h.n -IPv6Address $h.v6 }
}
Neu $zone 'intranet'  'CNAME' "fs01.$zone"            { Add-DnsServerResourceRecord -ZoneName $zone -CName -Name 'intranet' -HostNameAlias "fs01.$zone" }
Neu $zone '.'         'MX'    "10 mail.$zone"         { Add-DnsServerResourceRecord -ZoneName $zone -MX -Name '.' -MailExchange "mail.$zone" -Preference 10 }
Neu $zone $ApexName   'TXT'   'v=spf1 mx -all'        { Add-DnsServerResourceRecord -ZoneName $zone -Txt -Name $ApexName -DescriptiveText 'v=spf1 mx -all' }
Neu $zone '_ldap._tcp' 'SRV'  "0 100 389 ns1.$zone"   { Add-DnsServerResourceRecord -ZoneName $zone -Srv -Name '_ldap._tcp' -DomainName "ns1.$zone" -Priority 0 -Weight 100 -Port 389 }
Neu $zone $ApexName   'NS'    "ns1.$dev (Partner)"    { Add-DnsServerResourceRecord -ZoneName $zone -NS -Name $ApexName -NameServer "ns1.$dev" }

# 3. PTR-Eintraege (IPv4: letztes Oktett; IPv6: 16 Nibbles des Hostanteils, umgekehrt)
$ptr = @(
    @{ okt = 51; v6 = '1.5'; ziel = "fs01.$zone" },
    @{ okt = 52; v6 = '2.5'; ziel = "mail.$zone" },
    @{ okt = 53; v6 = '3.5'; ziel = "erp.$zone" },
    @{ okt = 61; v6 = '1.6'; ziel = "git.$dev" },
    @{ okt = 62; v6 = '2.6'; ziel = "ci.$dev" },
    @{ okt = 63; v6 = '3.6'; ziel = "build.$dev" }
)
foreach ($p in $ptr) {
    $name6 = $p.v6 + '.0.0.0.0.0.0.0.0.0.0.0.0.0.0'      # 2 + 14 Nibbles = 16
    Neu $rev4 "$($p.okt)" 'PTR' $p.ziel { Add-DnsServerResourceRecord -ZoneName $rev4 -Ptr -Name "$($p.okt)" -PtrDomainName $p.ziel }
    Neu $rev6 $name6      'PTR' $p.ziel { Add-DnsServerResourceRecord -ZoneName $rev6 -Ptr -Name $name6    -PtrDomainName $p.ziel }
}

# 4. Transfer und NOTIFY der Zone hq nur an den Partner
if ($PSCmdlet.ShouldProcess($zone, "Transfer und NOTIFY nur an $Partner")) {
    Set-DnsServerPrimaryZone -Name $zone -SecureSecondaries TransferToSecureServers -SecondaryServers $Partner `
                             -Notify NotifyServers -NotifyServers $Partner
    Write-Host "gesetzt    Transfer/NOTIFY nur an $Partner in $zone"
}

# 5. Sekundaere Zone dev
if (Get-DnsServerZone -Name $dev -ErrorAction SilentlyContinue) {
    Write-Host "Zone $dev existiert bereits."
} elseif ($PSCmdlet.ShouldProcess($dev, "Sekundaere Zone anlegen (Primaerserver $Partner)")) {
    Add-DnsServerSecondaryZone -Name $dev -ZoneFile "$dev.dns" -MasterServers $Partner
    Write-Host "Sekundaere Zone $dev angelegt."
}
if ($PSCmdlet.ShouldProcess($dev, 'Zonenuebertragung anstossen')) {
    Start-DnsServerZoneTransfer -Name $dev
    Start-Sleep -Seconds 3
}

if (-not $WhatIfPreference) {
    Get-DnsServerZone | Where-Object { $_.ZoneName -in $zone, $dev, $rev4, $rev6 } | Format-Table ZoneName, ZoneType -AutoSize
    Write-Host "`nHINWEIS: Die Transferbeschraenkung der sekundaeren Zone $dev ist NICHT gesetzt. Oberflaeche: DNS-Manager -> $dev -> Eigenschaften -> Zonenuebertragungen -> Zonenuebertragungen zulassen abwaehlen."
    Write-Host 'Alternativ (NICHT bestaetigt): dnscmd /ZoneResetSecondaries dev.alpentech.internal /NoXfr'
}
