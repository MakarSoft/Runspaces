# Добавляем аргументы в ScriptBlock

Clear-Host

$ParamList = @{
    Param1 = "Параметр_1"
    Param2 = "Параметр_2"
}
$PowerShell = [Management.Automation.PowerShell]::Create()

# .AddParameters()

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
        }).AddParameters($ParamList)

# Просмотр переданных параметров ...
$PowerShell.Commands.Commands.Parameters

$PowerShell.Invoke()
$PowerShell.Dispose()
