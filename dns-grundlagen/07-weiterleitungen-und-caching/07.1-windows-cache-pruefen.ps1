<#
.SYNOPSIS
    Zeigt den Cache des Windows-DNS-Servers und des Clients an und leert ihn auf Wunsch (Uebung 07.1, Teil 6).
.DESCRIPTION
    Ohne Schalter wird nur angezeigt. Mit -ServerCacheLeeren wird Clear-DnsServerCache ausgefuehrt,
    mit -ClientCacheLeeren Clear-DnsClientCache. Als Administrator ausfuehren. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Filter = 'partner.example.net',
    [switch]$ServerCacheLeeren,
    [switch]$ClientCacheLeeren
)

Write-Host "== Server-Cache (Eintraege, die '$Filter' enthalten)"
$treffer = Show-DnsServerCache | Where-Object { $_.HostName -like "*$Filter*" -or $_.DistinguishedName -like "*$Filter*" }
if ($treffer) { $treffer | Format-Table HostName, RecordType, TimeToLive, RecordData -AutoSize }
else { Write-Host '(keine Treffer)' }

Write-Host "`n== Client-Cache"
Get-DnsClientCache | Where-Object { $_.Entry -like "*$Filter*" } | Format-Table Entry, Type, TimeToLive, Data -AutoSize

if ($ServerCacheLeeren -and $PSCmdlet.ShouldProcess('DNS-Server', 'Cache leeren')) {
    Clear-DnsServerCache -Force
    Write-Host 'Server-Cache geleert.'
}
if ($ClientCacheLeeren -and $PSCmdlet.ShouldProcess('Client', 'Cache leeren')) {
    Clear-DnsClientCache
    Write-Host 'Client-Cache geleert.'
}
