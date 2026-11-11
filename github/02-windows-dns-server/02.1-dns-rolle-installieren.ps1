<#
.SYNOPSIS
    Installiert die DNS-Server-Rolle mit Verwaltungswerkzeugen auf SRV-WIN-DNS (Uebung 02.1, Teil 1).
.DESCRIPTION
    Prueft zuerst, ob die Rolle schon da ist, installiert nur bei Bedarf und zeigt danach Dienststatus,
    Startart und die Dateien im DNS-Verzeichnis. Laeuft mehrfach ohne Schaden.
    Muss in einer PowerShell als Administrator auf dem Windows Server laufen. Mit -WhatIf wird nichts installiert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param()

$rolle = Get-WindowsFeature -Name DNS
if ($null -eq $rolle) {
    throw 'Get-WindowsFeature nicht verfuegbar: Das Skript gehoert auf Windows Server.'
}

if ($rolle.Installed) {
    Write-Host 'DNS-Rolle ist bereits installiert.'
} elseif ($PSCmdlet.ShouldProcess('SRV-WIN-DNS', 'DNS-Rolle mit Verwaltungswerkzeugen installieren')) {
    $ergebnis = Install-WindowsFeature -Name DNS -IncludeManagementTools
    Write-Host ("Installation erfolgreich: {0}; Neustart erforderlich: {1}" -f $ergebnis.Success, $ergebnis.RestartNeeded)
}

$dienst = Get-Service -Name DNS -ErrorAction SilentlyContinue
if ($dienst) {
    $start = (Get-CimInstance -ClassName Win32_Service -Filter "Name='DNS'").StartMode
    Write-Host ("Dienst DNS: Status {0}, Startart {1}" -f $dienst.Status, $start)
}

$verzeichnis = Join-Path $env:SystemRoot 'System32\dns'
if (Test-Path -LiteralPath $verzeichnis) {
    Write-Host "Inhalt von ${verzeichnis}:"
    Get-ChildItem -LiteralPath $verzeichnis | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize
}
