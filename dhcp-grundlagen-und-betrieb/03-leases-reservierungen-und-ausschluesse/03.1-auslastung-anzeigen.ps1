<#
.SYNOPSIS
    Zeigt die Auslastung eines Scopes in Prozent (Uebung 03.1, Teil 4).
.DESCRIPTION
    Liest Get-DhcpServerv4ScopeStatistics und rechnet InUse / (InUse + Free) * 100.
    Die Eigenschaftsnamen InUse und Free sind nicht bestaetigt: Fehlen sie, listet das Skript die
    vorhandenen Eigenschaften auf und bricht ab. Aendert nichts am Server.
#>
[CmdletBinding()]
param([string]$ScopeId = '192.168.10.0')

$s = Get-DhcpServerv4ScopeStatistics -ScopeId $ScopeId
$namen = $s.PSObject.Properties.Name
if (($namen -notcontains 'InUse') -or ($namen -notcontains 'Free')) {
    Write-Warning ("Erwartete Eigenschaften fehlen. Vorhanden: " + ($namen -join ', '))
    return
}
$gesamt = $s.InUse + $s.Free
$prozent = if ($gesamt -gt 0) { [math]::Round(100 * $s.InUse / $gesamt, 1) } else { 0 }
[pscustomobject]@{
    ScopeId    = $ScopeId
    InUse      = $s.InUse
    Free       = $s.Free
    Auslastung = "$prozent %"
}
