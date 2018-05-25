#===============================================================================
#
#===============================================================================

[int32]$i = 0

#===============================================================================
Write-Host ("=" * 36) -NoNewline
Write-Host ("<{0,2:00}>" -f ++$i) -NoNewline
Write-Host ("=" * 36)

[Management.Automation.PowerShell]::Create().AddCommand("Get-Location").Invoke()
Start-Sleep -Seconds 3  # ждем завершения выполнения команды

#===============================================================================
Write-Host ("=" * 36) -NoNewline
Write-Host ("<{0,2:00}>" -f ++$i) -NoNewline
Write-Host ("=" * 36)

[Management.Automation.PowerShell]::Create().AddCommand("Get-ChildItem").AddParameter('Filter', '*.PS1').AddParameter('Path', 'C:\Temp').Invoke()
Start-Sleep -Seconds 3 # ждем завершения выполнения команды

#===============================================================================
Write-Host ("=" * 36) -NoNewline
Write-Host ("<{0,2:00}>" -f ++$i) -NoNewline
Write-Host ("="*36)

# альтернатива, с использованием hashtable и метода AddParameters()
$Params = @{
    Path    = "C:\Temp"
    Filter  = "*.PS1"
}
[Management.Automation.PowerShell]::Create().AddCommand("Get-ChildItem").AddParameters($Params).Invoke()
Start-Sleep -Seconds 3 # ждем завершения выполнения команды
#===============================================================================
