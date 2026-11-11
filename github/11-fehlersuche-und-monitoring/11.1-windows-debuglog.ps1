<#
.SYNOPSIS
    Schaltet die Debug-Protokollierung des Windows-DNS-Servers ein oder aus (Uebung 11.1, Teil 4).
.DESCRIPTION
    -Starten   : Protokolliert Abfragen und Antworten (UDP und TCP, ein- und ausgehend) in die Datei aus -LogDatei.
    -Beenden   : Schaltet die Protokollierung in die Datei wieder aus.
    Ohne Schalter wird nur der aktuelle Stand angezeigt. Mit -WhatIf wird nichts geaendert.
    Die Parameternamen stimmen mit der Beschreibung von Set-DnsServerDiagnostics auf Microsoft Learn ueberein;
    das Verhalten auf dem Server wurde nicht geprueft. Die Protokolldatei kann schnell gross werden: nach dem Test beenden.
    Als Administrator auf SRV-WIN-DNS ausfuehren.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$Starten,
    [switch]$Beenden,
    [string]$LogDatei = 'C:\DNS-Logs\dns-debug.log',
    [uint32]$MaxMB = 50
)

Write-Host '== Aktueller Stand'
Get-DnsServerDiagnostics | Select-Object EnableLoggingToFile, LogFilePath, MaxMBFileSize, Queries, Answers, SendPackets, ReceivePackets, UdpPackets, TcpPackets, FullPackets | Format-List

if ($Starten -and $PSCmdlet.ShouldProcess('SRV-WIN-DNS', "Debug-Protokollierung nach $LogDatei einschalten")) {
    $ordner = Split-Path -Parent $LogDatei
    if (-not (Test-Path $ordner)) { New-Item -ItemType Directory -Path $ordner | Out-Null }
    Set-DnsServerDiagnostics -EnableLoggingToFile $true -LogFilePath $LogDatei -MaxMBFileSize $MaxMB -EnableLogFileRollover $true `
        -Queries $true -Answers $true -QuestionTransactions $true `
        -SendPackets $true -ReceivePackets $true -UdpPackets $true -TcpPackets $true -FullPackets $true
    Write-Host "Debug-Protokollierung ein. Datei: $LogDatei"
}

if ($Beenden -and $PSCmdlet.ShouldProcess('SRV-WIN-DNS', 'Debug-Protokollierung ausschalten')) {
    Set-DnsServerDiagnostics -EnableLoggingToFile $false -Queries $false -Answers $false -QuestionTransactions $false `
        -SendPackets $false -ReceivePackets $false -UdpPackets $false -TcpPackets $false -FullPackets $false
    Write-Host 'Debug-Protokollierung aus.'
}
