# Добавляем переменные в ScriptBlock

Clear-Host

$PowerShell = [Management.Automation.PowerShell]::Create()

$global:Param1 = "Параметр_1"
$global:Param2 = "Параметр_2"

[void]$PowerShell.AddScript({
            $x = [PSCustomObject]@{
                Param1 = $Param1
                Param2 = $Param2
            }
            Write-Output ("Переменные: {0}; {1}" -f $x.Param1, $x.Param2)
        })

# Просмотр команд ...
$PowerShell.Commands.Commands

$PowerShell.Invoke()
$PowerShell.Dispose()
