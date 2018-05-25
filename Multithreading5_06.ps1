# Добавляем аргументы в ScriptBlock

Clear-Host

$PowerShell = [Management.Automation.PowerShell]::Create()

[System.String]$Param1 = "Параметр_1"
[System.String]$Param2 = "Параметр_2"

# .AddParameter()
# Именованные параметры ...
# В данном случае, порядок не важен.
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
        }).AddParameter('Param2',$Param2).AddParameter('Param1',$Param1)

# Просмотр переданных параметров ...
$PowerShell.Commands.Commands.Parameters

$PowerShell.Invoke()
$PowerShell.Dispose()
