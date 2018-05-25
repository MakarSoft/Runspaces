#===============================================================================
# Добавляем переменные в ScriptBlock
# Плохой вариант...
# https://github.com/proxb/Presentations/tree/master/Art_Of_PowerShell_Runspaces
# https://blogs.technet.microsoft.com/heyscriptingguy/2015/11/26/beginning-use-of-powershell-runspaces-part-1/
#===============================================================================

Clear-Host

$PowerShell = [Management.Automation.PowerShell]::Create()

$global:Param1 = "Параметр_1"
$global:Param2 = "Параметр_2"

[void]$PowerShell.AddScript({
            $x = [PSCustomObject]@{
                Param1 = $global:Param1
                Param2 = $global:Param2
            }
            Write-Output ("Переменные: {0}; {1}" -f $x.Param1, $x.Param2)
        })

# Просмотр команд ...
$PowerShell.Commands.Commands

$PowerShell.Invoke()
$PowerShell.Dispose()
