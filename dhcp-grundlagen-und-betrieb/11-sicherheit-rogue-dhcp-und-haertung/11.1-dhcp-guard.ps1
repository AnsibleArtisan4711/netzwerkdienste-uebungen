<#
.SYNOPSIS
    Schaltet DHCP Guard fuer die Netzwerkkarten der angegebenen VMs ein oder aus (Uebung 11.1, Teil 2).
.DESCRIPTION
    Set-VMNetworkAdapter -VMName ... -DhcpGuard On|Off (laut Microsoft Learn). Mit DHCP Guard werden
    DHCP-Antworten einer VM verworfen. Darf nur auf VMs eingeschaltet werden, die KEIN DHCP-Server sind
    (also nicht auf SRV-WIN-DHCP1, SRV-WIN-DHCP2, SRV-LIN-KEA und nicht auf RTR-LIN, wenn dort ein Relay laeuft;
    ob ein Relay betroffen ist, ist nicht bestaetigt).
    Auf dem Hyper-V-Host als Administrator ausfuehren. Mit -WhatIf wird nichts geaendert.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)][string[]]$VMName,
    [ValidateSet('On', 'Off')][string]$Zustand = 'On'
)

foreach ($vm in $VMName) {
    if ($PSCmdlet.ShouldProcess($vm, "DHCP Guard $Zustand")) {
        Set-VMNetworkAdapter -VMName $vm -DhcpGuard $Zustand
    }
}
Get-VMNetworkAdapter -VMName $VMName -ErrorAction SilentlyContinue |
    Select-Object VMName, Name, DhcpGuard, RouterGuard
