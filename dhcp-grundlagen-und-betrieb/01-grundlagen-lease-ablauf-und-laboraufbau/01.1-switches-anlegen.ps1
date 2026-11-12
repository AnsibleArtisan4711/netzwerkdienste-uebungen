<#
.SYNOPSIS
    Legt die drei privaten Hyper-V-Switches des DHCP-Labors an (Uebung 01.1, Teil 1).
.DESCRIPTION
    vSwitch-Server, vSwitch-ClientA, vSwitch-ClientB, jeweils Typ Private. Vorhandene Switches
    mit gleichem Namen werden nicht veraendert. Muss auf dem Hyper-V-Host als Administrator laufen.
    Mit -WhatIf wird nichts angelegt.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param()

$namen = 'vSwitch-Server', 'vSwitch-ClientA', 'vSwitch-ClientB'
foreach ($name in $namen) {
    if (Get-VMSwitch -Name $name -ErrorAction SilentlyContinue) {
        Write-Host "$name existiert bereits, wird uebersprungen."
        continue
    }
    if ($PSCmdlet.ShouldProcess($name, 'Privaten virtuellen Switch anlegen')) {
        New-VMSwitch -Name $name -SwitchType Private | Out-Null
        Write-Host "$name angelegt."
    }
}
Get-VMSwitch | Where-Object Name -like 'vSwitch-*' | Select-Object Name, SwitchType
