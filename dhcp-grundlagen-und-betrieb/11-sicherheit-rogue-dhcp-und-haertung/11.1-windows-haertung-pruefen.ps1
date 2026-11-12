<#
.SYNOPSIS
    Nur-Lese-Pruefung der Haertung eines Windows-DHCP-Servers (Uebung 11.1, Teil 3).
.DESCRIPTION
    Zeigt: Autorisierung, Audit-Log-Einstellungen, lokale DHCP-Sicherheitsgruppen und deren Mitglieder,
    Filterliste (Zulassen/Verweigern), Konfliktpruefung. Aendert nichts.
    Ob jede Ausgabe auf deinem System genau so erscheint, ist nicht bestaetigt.
    Auf SRV-WIN-DHCP1 als Administrator ausfuehren.
#>
[CmdletBinding()]
param()

Write-Host '== Autorisierung in Active Directory'
Get-DhcpServerInDC -ErrorAction SilentlyContinue

Write-Host '== Audit-Log-Einstellungen (nur Einstellungen, nicht Inhalt)'
Get-DhcpServerAuditLog -ErrorAction SilentlyContinue | Format-List

Write-Host '== Lokale DHCP-Gruppen und Mitglieder'
foreach ($g in 'DHCP Administrators', 'DHCP Users') {
    Write-Host "-- $g"
    Get-LocalGroupMember -Group $g -ErrorAction SilentlyContinue | Select-Object Name, ObjectClass
}

Write-Host '== MAC-Filterliste (Zulassen/Verweigern)'
Get-DhcpServerv4FilterList -ErrorAction SilentlyContinue | Format-List

Write-Host '== Konfliktpruefung (Standard 0 Versuche)'
Get-DhcpServerSetting -ErrorAction SilentlyContinue | Select-Object ConflictDetectionAttempts
