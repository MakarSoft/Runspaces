#===============================================================================
# Запуск одной строкой
# --------------------
#
#   Создание экземпляра PowerShell
#   [Management.Automation.PowerShell]::Create()
#
#   Добавление команды   
#   .AddCommand('команда')
#
#   Добавление параметров
#   .AddParameter('имя_параметра', <значение_параметра>)
#   .AddParameters(<hash_ИмяПараметра_Значение>)

#   Вызвать на выполнение
#   .Invoke()
#
# https://github.com/proxb/Presentations/tree/master/Art_Of_PowerShell_Runspaces
# https://blogs.technet.microsoft.com/heyscriptingguy/2015/11/26/beginning-use-of-powershell-runspaces-part-1/

#===============================================================================

[int32]$i = 0   # текущий номер пункта
[System.String]$line = "=" * 38

#==============================================================================
#Write-Host ("=" * 38) -NoNewline
#Write-Host ("<{0,2:00}>" -f ++$i) -NoNewline
#Write-Host ("=" * 38)
Write-Host ("{0}<{1,2:00}>{0}" -f $line, ++$i)

# Создать экземпляр PowerShell,
# передеть на выполнение команду Get-Location и выполнить ее ...
[Management.Automation.PowerShell]::Create().AddCommand("Get-Location").Invoke()

# ждем завершения выполнения команды ...
Start-Sleep -Seconds 3

#===============================================================================
Write-Host ("{0}<{1,2:00}>{0}" -f $line, ++$i)

# Создать экземпляр PowerShell,
# передеть на выполнение команду Get-ChildItem,
# задать значение именованным параметрам и выполнить команду ...
[Management.Automation.PowerShell]::Create().AddCommand("Get-ChildItem").AddParameter('Filter', '*.PS1').AddParameter('Path', 'C:\Temp').Invoke()

# ждем завершения выполнения команды ...
Start-Sleep -Seconds 3 

#===============================================================================
Write-Host ("{0}<{1,2:00}>{0}" -f $line, ++$i)

# альтернатива, с использованием hashtable и метода AddParameters()
$Params = @{
    Path    = "C:\Temp"
    Filter  = "*.PS1"
}
[Management.Automation.PowerShell]::Create().AddCommand("Get-ChildItem").AddParameters($Params).Invoke()

# ждем завершения выполнения команды
Start-Sleep -Seconds 3

#===============================================================================
