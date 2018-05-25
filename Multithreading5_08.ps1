#region Show currenty ID and Thread for PowerShell.exe

## Check if running on same Process ID but in different Thread

$x1 = [PSCustomObject]@{
    Type       = 'Standard'
    ProcessId  = $PID
    Thread     = [appdomain]::GetCurrentThreadId()
    TotalThreads = (Get-Process -id $PID).Threads.count
}
Write-Output ("Type = {0,10}; ProcessId = {1,-6}; Thread = {2,-6}; TotalThreads = {3,-4}" -f  $x1.Type, $x1.ProcessId, $x1.Thread, $x1.TotalThreads)

# Show Process ID and thread for new runspace
$PowerShell = [Management.Automation.PowerShell]::Create()
[void]$PowerShell.AddScript({
            $x2 = [PSCustomObject]@{
                Type       = 'Runspace'
                ProcessId  = $PID
                Thread     = [appdomain]::GetCurrentThreadId()
                TotalThreads = (get-process -id $PID).Threads.count
            }
            Write-Output ("Type = {0,10}; ProcessId = {1,-6}; Thread = {2,-6}; TotalThreads = {3,-4}" -f $x2.Type, $x2.ProcessId, $x2.Thread, $x2.TotalThreads)
        })
#Invoke the command
$PowerShell.Invoke()
$PowerShell.Dispose()

#Check threads again
$x3 = [PSCustomObject]@{
    Type       = 'Standard'
    ProcessId  = $PID
    Thread     = [appdomain]::GetCurrentThreadId()
    TotalThreads = (get-process -id $PID).Threads.count
}
Write-Output ("Type = {0,10}; ProcessId = {1,-6}; Thread = {2,-6}; TotalThreads = {3,-4}" -f $x3.Type, $x3.ProcessId, $x3.Thread, $x3.TotalThreads)

#region Using PSJobs
[void](Start-Job -Name Thread -ScriptBlock {
            $x4 = [PSCustomObject]@{
                Type       = 'PSJob'
                ProcessId  = $PID
                Thread     = [appdomain]::GetCurrentThreadId()
                TotalThreads = (get-process -id $PID).Threads.count
            }
            Write-Output ("Type = {0,10}; ProcessId = {1,-6}; Thread = {2,-6}; TotalThreads = {3,-4}" -f $x4.Type, $x4.ProcessId, $x4.Thread, $x4.TotalThreads)
        })
[void](Wait-Job -Name Thread)
Receive-Job -Name Thread | Select-Object Type, ProcessID, Thread, TotalThreads
Remove-Job -Name Thread

#endregion

#endregion

