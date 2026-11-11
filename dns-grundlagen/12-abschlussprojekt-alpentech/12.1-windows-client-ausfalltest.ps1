<#
.SYNOPSIS
    Hochverfuegbarkeitstest von CLI-TEST-01 (Uebung 12.1, Teil 4): zweiter DNS-Server, Abfragen, Bereinigung.
.DESCRIPTION
    -Beginn   : Traegt 192.168.50.10 (primaer) und 192.168.50.11 (sekundaer) als DNS-Server der Netzwerkkarte ein.
    -Pruefen  : Leert den Client-Cache und loest alle Eintraege beider Zonen ueber den Standard-Resolver des Clients auf
                (A, AAAA, CNAME, MX, TXT, SRV und PTR fuer IPv4 und IPv6). Gibt je Eintrag OK oder FEHLT aus.
    -Ende     : BEREINIGUNG. Stellt nur 192.168.50.10 als DNS-Server ein, damit die Domaenenanmeldung nicht durch einen
                DNS-Server ohne AD-Eintraege gestoert wird (CLI-TEST-01 ist seit Modul 8 Domaenenmitglied).
    Der Dienst auf SRV-WIN-DNS wird NICHT von diesem Skript gestoppt: Stop-Service DNS bzw. Start-Service DNS fuehrst du
    selbst auf SRV-WIN-DNS aus. Als Administrator auf CLI-TEST-01 ausfuehren. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$Beginn,
    [switch]$Pruefen,
    [switch]$Ende,
    [string]$InterfaceAlias,
    [string]$Primaer   = '192.168.50.10',
    [string]$Sekundaer = '192.168.50.11'
)

if (-not $InterfaceAlias) {
    $InterfaceAlias = (Get-NetAdapter | Where-Object Status -eq 'Up' | Select-Object -First 1).Name
}
Write-Host "Netzwerkkarte: $InterfaceAlias"

if ($Beginn -and $PSCmdlet.ShouldProcess($InterfaceAlias, "DNS-Server $Primaer und $Sekundaer eintragen")) {
    Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses $Primaer, $Sekundaer
    Write-Host "DNS-Server gesetzt: $Primaer, $Sekundaer"
}

if ($Pruefen) {
    Clear-DnsClientCache
    $fehler = 0
    function Teste([string]$Name, [string]$Typ, [string]$Erwartet) {
        $r = Resolve-DnsName -Name $Name -Type $Typ -DnsOnly -ErrorAction SilentlyContinue
        $text = ($r | ForEach-Object { "$($_.IPAddress)$($_.NameHost)$($_.NameExchange)$($_.Strings)$($_.NameTarget)" }) -join ' '
        if ($text -like "*$Erwartet*") { Write-Host "OK      $Typ $Name" }
        else { Write-Host "FEHLT   $Typ $Name  (erwartet '$Erwartet', erhalten '$text')"; $script:fehler++ }
    }
    foreach ($h in @(@('ns1.hq', '10'), @('fs01.hq', '51'), @('mail.hq', '52'), @('erp.hq', '53'), @('ns1.dev', '11'), @('git.dev', '61'), @('ci.dev', '62'), @('build.dev', '63'))) {
        Teste "$($h[0]).alpentech.internal" 'A'    "192.168.50.$($h[1])"
        Teste "$($h[0]).alpentech.internal" 'AAAA' "fd00:50::$($h[1])"
    }
    Teste 'intranet.hq.alpentech.internal' 'CNAME' 'fs01.hq.alpentech.internal'
    Teste 'wiki.dev.alpentech.internal'    'CNAME' 'git.dev.alpentech.internal'
    Teste 'hq.alpentech.internal'  'MX'  'mail.hq.alpentech.internal'
    Teste 'dev.alpentech.internal' 'MX'  'mail.hq.alpentech.internal'
    Teste 'hq.alpentech.internal'  'TXT' 'v=spf1'
    Teste 'dev.alpentech.internal' 'TXT' 'v=spf1'
    Teste '_ldap._tcp.hq.alpentech.internal' 'SRV' 'ns1.hq.alpentech.internal'
    Teste '_git._tcp.dev.alpentech.internal' 'SRV' 'git.dev.alpentech.internal'
    foreach ($p in @(@(51, 'fs01.hq'), @(52, 'mail.hq'), @(53, 'erp.hq'), @(61, 'git.dev'), @(62, 'ci.dev'), @(63, 'build.dev'))) {
        Teste "$($p[0]).50.168.192.in-addr.arpa" 'PTR' "$($p[1]).alpentech.internal"
        $n6 = ((('{0:D16}' -f $p[0])[15..0]) -join '.')   # Ziffern 51 -> 0000000000000051 -> umgekehrt + '.0.0.0.0.0.0.0.0.0.5.0.0.0.0.d.f.ip6.arpa'
        Teste $n6 'PTR' "$($p[1]).alpentech.internal"
    }
    Write-Host "`nFehler: $fehler"
}

if ($Ende -and $PSCmdlet.ShouldProcess($InterfaceAlias, "Nur $Primaer als DNS-Server eintragen")) {
    Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses $Primaer
    Clear-DnsClientCache
    Write-Host "Bereinigt: nur $Primaer als DNS-Server eingetragen."
}

Write-Host "`nAktuelle DNS-Server:"
Get-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -AddressFamily IPv4 | Format-Table InterfaceAlias, ServerAddresses -AutoSize
