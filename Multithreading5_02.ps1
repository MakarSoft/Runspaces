﻿#===============================================================================
#
# https://github.com/proxb/Presentations/tree/master/Art_Of_PowerShell_Runspaces
# https://blogs.technet.microsoft.com/heyscriptingguy/2015/11/26/beginning-use-of-powershell-runspaces-part-1/
#===============================================================================

$PowerShell = [Management.Automation.PowerShell]::Create()
Write-Host ("`$PowerShell.GetType() -> {0}" -f $PowerShell.GetType())
$PowerShell | Get-Member

[void]$PowerShell.AddScript({
    #Start-Sleep -Seconds 3 
    Get-Date
})

# Просмотр команд ...
$PowerShell.Commands.Commands
# Вывод:
# ...
# Parameters                           : {}
# CommandText                          :
#                                        #Start-Sleep -Seconds 3
#                                        Get-Date
#
# IsScript                             : True
# UseLocalScope                        : False
# CommandOrigin                        : Runspace
# IsEndOfStatement                     : False
# MergeUnclaimedPreviousCommandResults : None

$PowerShell.Invoke()
$PowerShell.Dispose()
