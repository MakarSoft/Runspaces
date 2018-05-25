# https://blogs.technet.microsoft.com/heyscriptingguy/2015/11/26/beginning-use-of-powershell-runspaces-part-1/

$PowerShell = [Management.Automation.PowerShell]::Create()

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
