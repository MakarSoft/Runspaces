﻿#===============================================================================
# Добавляем аргументы в ScriptBlock
# https://github.com/proxb/Presentations/tree/master/Art_Of_PowerShell_Runspaces
# https://blogs.technet.microsoft.com/heyscriptingguy/2015/11/26/beginning-use-of-powershell-runspaces-part-1/
#
#===============================================================================

Clear-Host

$PowerShell = [Management.Automation.PowerShell]::Create()

[System.String]$Param1 = "Параметр_1"
[System.String]$Param2 = "Параметр_2"

[void]$PowerShell.AddScript({
            param (
                    [System.String]$Param1,
                    [System.String]$Param2
            )
            $x = [PSCustomObject]@{
                Param1 = $Param1
                Param2 = $Param2
            }
            Write-Output ("Переданные параметры: {0}; {1}" -f $x.Param1, $x.Param2)
        }).AddArgument($Param1).AddArgument($Param2)

# Просмотр переданных параметров ...
#$PowerShell.Commands.Commands.Parameters
$PowerShell.Commands.Commands

$PowerShell.Invoke()
$PowerShell.Dispose()
