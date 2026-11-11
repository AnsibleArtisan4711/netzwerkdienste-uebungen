<#
.SYNOPSIS
    Legt auf SRV-WIN-DNS die Forward-Eintraege der Zone corp.example.com an (Uebung 05.1, Teil 1).
.DESCRIPTION
    Legt A, AAAA, CNAME, MX, TXT und SRV an. Bereits vorhandene Eintraege gleichen Namens und Typs
    werden uebersprungen (geprueft wird nur Name und Typ, nicht der Wert).
    Alle Eintraege werden ohne -AgeRecord angelegt, sind also statisch (Zeitstempel 0) und werden
    nie aufgeraeumt (siehe Uebung 08.1).
    Hinweis zu den Namen: Fuer den Zonenursprung (Apex) verwendet das MX-Beispiel in Microsoft Learn
    den Namen ".". Fuer den TXT-Eintrag am Apex wird hier "@" verwendet; das ist NICHT bestaetigt.
    Falls Windows "@" ablehnt, den Parameter -ApexName '.' angeben.
    Die Zone muss existieren (Uebung 04.1). Als Administrator ausfuehren. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Zone      = 'corp.example.com',
    [string]$ApexName  = '@'
)

function Neu {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param([string]$Name, [string]$Typ, [string]$Text, [scriptblock]$Aktion)
    $anzeige = if ($Name -in '@', '.') { $Zone } else { "$Name.$Zone" }
    $vorhanden = Get-DnsServerResourceRecord -ZoneName $Zone -Name $Name -RRType $Typ -ErrorAction SilentlyContinue
    if ($vorhanden) { Write-Host "vorhanden  $Typ  $anzeige"; return }
    if ($PSCmdlet.ShouldProcess("$anzeige ($Typ)", "Anlegen: $Text")) {
        & $Aktion
        Write-Host "angelegt   $Typ  $anzeige  ($Text)"
    }
}

# 1. Adressen: A (IPv4) und AAAA (IPv6)
Neu 'winserver' 'A'    '192.168.50.10' { Add-DnsServerResourceRecord -ZoneName $Zone -A    -Name 'winserver' -IPv4Address '192.168.50.10' }
Neu 'winserver' 'AAAA' 'fd00:50::10'   { Add-DnsServerResourceRecord -ZoneName $Zone -AAAA -Name 'winserver' -IPv6Address 'fd00:50::10' }
Neu 'files'     'A'    '192.168.50.20' { Add-DnsServerResourceRecord -ZoneName $Zone -A    -Name 'files'     -IPv4Address '192.168.50.20' }
Neu 'files'     'AAAA' 'fd00:50::20'   { Add-DnsServerResourceRecord -ZoneName $Zone -AAAA -Name 'files'     -IPv6Address 'fd00:50::20' }

# 2. Alias: intranet ist ein anderer Name fuer files
Neu 'intranet'  'CNAME' 'files.corp.example.com' { Add-DnsServerResourceRecord -ZoneName $Zone -CName -Name 'intranet' -HostNameAlias 'files.corp.example.com' }

# 3. Mail: A-Eintrag fuer mail, MX am Apex (Praeferenz 10)
Neu 'mail'      'A'    '192.168.50.25' { Add-DnsServerResourceRecord -ZoneName $Zone -A -Name 'mail' -IPv4Address '192.168.50.25' }
Neu '.'         'MX'   'MX 10 mail.corp.example.com' { Add-DnsServerResourceRecord -ZoneName $Zone -MX -Name '.' -MailExchange 'mail.corp.example.com' -Preference 10 }

# 4. TXT am Apex (SPF)
Neu $ApexName   'TXT'  'v=spf1 mx -all' { Add-DnsServerResourceRecord -ZoneName $Zone -Txt -Name $ApexName -DescriptiveText 'v=spf1 mx -all' }

# 5. Dienst: SIP ueber TCP (Prioritaet 10, Gewichtung 100, Port 5060), A-Eintrag fuer voip
Neu 'voip'      'A'    '192.168.50.30' { Add-DnsServerResourceRecord -ZoneName $Zone -A -Name 'voip' -IPv4Address '192.168.50.30' }
Neu '_sip._tcp' 'SRV'  'SRV 10 100 5060 voip.corp.example.com' { Add-DnsServerResourceRecord -ZoneName $Zone -Srv -Name '_sip._tcp' -DomainName 'voip.corp.example.com' -Priority 10 -Weight 100 -Port 5060 }

# 6. Ergebnis
if (-not $WhatIfPreference) {
    Get-DnsServerResourceRecord -ZoneName $Zone | Sort-Object RecordType, HostName |
        Format-Table HostName, RecordType, @{ n = 'Daten'; e = { $_.RecordData } } -AutoSize
}
