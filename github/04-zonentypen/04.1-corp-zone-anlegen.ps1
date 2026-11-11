<#
.SYNOPSIS
    Legt auf SRV-WIN-DNS die dateibasierte primaere Zone corp.example.com an (Uebung 04.1, Teil 3).
.DESCRIPTION
    - Legt die Zone mit der Datei corp.example.com.dns an, falls sie noch nicht existiert.
    - Setzt im SOA-Eintrag Refresh = 15 Minuten und Retry = 5 Minuten.
    - Traegt einen A-Eintrag fuer winserver (192.168.50.10) ein.
    Das Setzen der SOA-Werte geht ueber Get-/Set-DnsServerResourceRecord mit -OldInputObject und
    -NewInputObject; die Eigenschaftsnamen RefreshInterval und RetryDelay stammen aus meinem Wissen und
    sind NICHT bestaetigt.
    Muss als Administrator auf SRV-WIN-DNS laufen. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Zone            = 'corp.example.com',
    [string]$ZoneFile        = 'corp.example.com.dns',
    [string]$Verantwortlich  = 'hostmaster.corp.example.com',
    [int]$RefreshMinuten     = 15,
    [int]$RetryMinuten       = 5,
    [string]$HostName        = 'winserver',
    [string]$HostAdresse     = '192.168.50.10'
)

# 1. Zone anlegen
if (Get-DnsServerZone -Name $Zone -ErrorAction SilentlyContinue) {
    Write-Host "Zone $Zone existiert bereits."
} elseif ($PSCmdlet.ShouldProcess($Zone, "Primaere Zone mit Datei $ZoneFile anlegen")) {
    Add-DnsServerPrimaryZone -Name $Zone -ZoneFile $ZoneFile -ResponsiblePerson $Verantwortlich
    Write-Host "Zone $Zone angelegt (Datei $ZoneFile)."
}

# 2. SOA-Werte setzen
$alt = Get-DnsServerResourceRecord -ZoneName $Zone -RRType SOA -ErrorAction SilentlyContinue
if ($alt) {
    $neu = $alt.Clone()
    $neu.RecordData.RefreshInterval = [TimeSpan]::FromMinutes($RefreshMinuten)
    $neu.RecordData.RetryDelay      = [TimeSpan]::FromMinutes($RetryMinuten)
    if ($PSCmdlet.ShouldProcess("$Zone SOA", "Refresh $RefreshMinuten min, Retry $RetryMinuten min setzen")) {
        Set-DnsServerResourceRecord -ZoneName $Zone -OldInputObject $alt -NewInputObject $neu
        Write-Host "SOA aktualisiert."
    }
}

# 3. A-Eintrag
$vorhanden = Get-DnsServerResourceRecord -ZoneName $Zone -Name $HostName -RRType A -ErrorAction SilentlyContinue
if ($vorhanden) {
    Write-Host "A-Eintrag $HostName existiert bereits."
} elseif ($PSCmdlet.ShouldProcess("$HostName.$Zone", "A-Eintrag $HostAdresse anlegen")) {
    Add-DnsServerResourceRecordA -ZoneName $Zone -Name $HostName -IPv4Address $HostAdresse
    Write-Host "A-Eintrag $HostName.$Zone -> $HostAdresse angelegt."
}

# 4. Ergebnis
if (-not $WhatIfPreference) {
    Get-DnsServerResourceRecord -ZoneName $Zone | Format-Table HostName, RecordType, @{n='Daten'; e={ $_.RecordData }} -AutoSize
}
