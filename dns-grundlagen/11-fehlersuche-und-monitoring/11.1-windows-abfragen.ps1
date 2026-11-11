<#
.SYNOPSIS
    Fuehrt die Diagnoseabfragen aus Uebung 11.1 (Teil 1 und Teil 4) mit Resolve-DnsName aus (nur lesend).
.DESCRIPTION
    Zeigt eine Abfrage mit -DnsOnly (keine hosts-Datei, kein LLMNR, kein NetBIOS), dieselbe mit -NoRecursion,
    eine Reverse-Abfrage und die letzten Eintraege des Ereignisprotokolls 'DNS Server' (nur auf dem DNS-Server).
    Auf CLI-TEST-01 oder SRV-WIN-DNS in PowerShell ausfuehren.
.PARAMETER Server
    DNS-Server, der gefragt wird (Standard 192.168.50.10).
#>
[CmdletBinding()]
param(
    [string]$Server = '192.168.50.10',
    [string]$Name = 'files.corp.example.com',
    [string]$ReverseIp = '192.168.50.10'
)

function Zeige([string]$titel, [scriptblock]$aufruf) {
    Write-Host "`n== $titel"
    try { & $aufruf | Format-Table -AutoSize } catch { Write-Host "Fehler: $($_.Exception.Message)" -ForegroundColor Yellow }
}

Zeige "A-Abfrage ohne hosts-Datei, LLMNR und NetBIOS (-DnsOnly)" { Resolve-DnsName -Name $Name -Type A -Server $Server -DnsOnly }
Zeige "A-Abfrage ohne Rekursion (-NoRecursion)"                  { Resolve-DnsName -Name $Name -Type A -Server $Server -DnsOnly -NoRecursion }
$ptrName = (($ReverseIp -split '\.')[3..0] -join '.') + '.in-addr.arpa'
Zeige "Reverse-Abfrage (PTR, $ptrName)"                          { Resolve-DnsName -Name $ptrName -Type PTR -Server $Server -DnsOnly }
Zeige "SOA der Zone"                                             { Resolve-DnsName -Name ($Name -replace '^[^.]+\.', '') -Type SOA -Server $Server -DnsOnly }

if (Get-Command Get-WinEvent -ErrorAction SilentlyContinue) {
    Write-Host "`n== Ereignisprotokoll 'DNS Server' (letzte 10 Eintraege; nur auf dem DNS-Server vorhanden)"
    try {
        Get-WinEvent -LogName 'DNS Server' -MaxEvents 10 -ErrorAction Stop |
            Format-Table TimeCreated, Id, LevelDisplayName, @{n = 'Meldung'; e = { ($_.Message -split "`n")[0] } } -AutoSize
    } catch { Write-Host "Ereignisprotokoll nicht lesbar: $($_.Exception.Message)" -ForegroundColor Yellow }
}
