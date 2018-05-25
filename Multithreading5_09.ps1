##Now onto the real fun of Runspaces!

#region Async approach (multithreading)

#region Non-Async
$PowerShell = [powershell]::Create()
#Now let it sleep for a couple seconds
[void]$PowerShell.AddScript({
            Start-Sleep -Seconds 2
            Get-Date
        })

#Invoke the command
$PowerShell.Invoke()
$PowerShell.Dispose()
#endregion

#region Async
$PowerShell = [powershell]::Create()

#Now let it sleep for a couple seconds
[void]$PowerShell.AddScript({
            Start-Sleep -Seconds 10
            [pscustomobject]@{
                ProcessId  = $PID
                Thread     = [appdomain]::GetCurrentThreadId()
                TotalThreads = (get-process -id $PID).Threads.count
            }
        })

#Take the same scriptblock and run it in the background
# System.Management.Automation.PowerShellAsyncResult
$Handle = $PowerShell.BeginInvoke()

#Notice IsCompleted property; tells us when command has completed
$Handle

#During this time we have free reign over the console
(Get-Process -id $PID).Threads | Select-Object Id, ThreadState, StartTime

#Check again
$Handle

#Get results
#EndInvoke waits for a pending async call and returns the results, if any
$PowerShell.EndInvoke($Handle)

#Perform cleanup
$PowerShell.Dispose()
#endregion

#region Serialized Object PSJob
$Process = Get-Process
$Process | Get-Member

$Job = Start-Job {
    Get-Process
}
[void]($job | Wait-Job)
$Data = $job | Receive-Job
Remove-Job $job

#Note the Typename and available methods compared to $Process
$Data | Get-Member

#View the methods
$Data | Get-Member -MemberType Method
$Process | Get-Member -MemberType Method
#endregion

#region Live Object Runspace
$PowerShell = [powershell]::Create()

#Now let it sleep for a couple seconds
[void]$PowerShell.AddScript({
            Get-Process
            Start-Sleep -Seconds 2
        })

#Take the same scriptblock and run it in the background
$Handle = $PowerShell.BeginInvoke()

while (-Not $handle.IsCompleted) {
    Write-Host "." -NoNewline; Start-Sleep -Milliseconds 100
}

#Get results
$Data = $PowerShell.EndInvoke($Handle)

#Perform cleanup
$PowerShell.Runspace.Close()
$PowerShell.Dispose()

#Note TypeName and available methods
$Data | Get-Member
#endregion

#endregion