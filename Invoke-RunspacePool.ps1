# https://imanage.com/blog/quickly-and-easily-threading-your-powershell-scripts/
function Invoke-RunspacePool {
    <#
        .SYNOPSIS
        Creates a new runspace pool, executing the ThreadBlock in multiple threads.

        .EXAMPLE
        Invoke-RunspacePool $cmd $args
    #>
    
    [CmdletBinding()]
    param (
            # Script block to execute in each thread.
            [Parameter(Mandatory = $True,
                       Position = 1)]
            [scriptblock]$ThreadBlock,
            # Set of arguments to pass to the thread. $threadId will always be added to this.

            [Parameter(Mandatory = $False,
                       Position = 2)]
            [hashtable]$ThreadParams,
            # Maximum number of threads. Default is the number of logical CPUs on the executing machine.

            [Parameter(Mandatory = $False,
                       Position = 3)]
            [int]$MaxThreads,
            # Garbage collector cleanup interval.

            [Parameter(Mandatory = $False)]
            [int]$CleanupInterval = 2,
            # Powershell modules to import into the RunspacePool.

            [Parameter(Mandatory = $False)]
            [String[]]$ImportModules,
            # Paths to modules to be imported into the RunspacePool.

            [Parameter(Mandatory = $False)]
            [String[]]$ImportModulesPath
    )
    
    if (!$MaxThreads) {
        $MaxThreads = ((Get-WmiObject Win32_Processor) `
                | Measure-Object -Sum -Property NumberOfLogicalProcessors).Sum
    }
    
    $sessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
    
    if ($ImportModules) {
        $ImportModules | ForEach-Object {
            $sessionState.ImportPSModule($_)
        }
    }
    
    if ($ImportModulesPath) {
        $ImportModulesPath | ForEach-Object {
            $sessionState.ImportPSModulesFromPath($_)
        }
    }
    
    $pool = [RunspaceFactory]::CreateRunspacePool(1, $MaxThreads, $sessionState, $Host)
    
    $pool.ApartmentState = "STA" # Single-threaded runspaces created
    $pool.CleanupInterval = $CleanupInterval * [timespan]::TicksPerMinute
    
    $pool.Open()
    
    $jobs = New-Object 'Collections.Generic.List[System.IAsyncResult]'
    $pipelines = New-Object 'Collections.Generic.List[System.Management.Automation.PowerShell]'
    $handles = New-Object 'Collections.Generic.List[System.Threading.WaitHandle]'
    
    for ($i = 1; $i -le $MaxThreads; $i++) {
        
        $pipeline = [powershell]::Create()
        $pipeline.RunspacePool = $pool
        $pipeline.AddScript($ThreadBlock) | Out-Null
        
        $params = @{
            'threadId'  = $i
        }
        
        if ($ThreadParams) {
            $params += $ThreadParams
        }
        
        $pipeline.AddParameters($params) | Out-Null
        
        $pipelines.Add($pipeline)
        
        $job = $pipeline.BeginInvoke()
        $jobs.Add($job)
        
        $handles.Add($job.AsyncWaitHandle)
    }
    
    while ($pipelines.Count -gt 0) {
        
        $h = [System.Threading.WaitHandle]::WaitAny($handles)
        
        $handle = $handles.Item($h)
        $job = $jobs.Item($h)
        $pipeline = $pipelines.Item($h)
        
        $result = $pipeline.EndInvoke($job)
        
        ### Process results here
        if ($PSBoundParameters['Verbose'].IsPresent) {
            Write-Host ""
        }
        Write-Verbose "Pipeline state: $($pipeline.InvocationStateInfo.State)"
        if ($pipeline.HadErrors) {
            $pipeline.Streams.Error.ReadAll() | ForEach-Object {
                Write-Error $_
            }
        }
        $result | ForEach-Object {
            Write-Verbose $_
        }
        
        $handles.RemoveAt($h)
        $jobs.RemoveAt($h)
        $pipelines.RemoveAt($h)
        
        $handle.Dispose()
        $pipeline.Dispose()
    }
    
    $pool.Close()
}

# 1.
$cmd = {
    param ($threadId,
            $var)
    "Thread id : $threadId"
    "Variable : $var"
}

# 2.
$args = @{
    var  = "Hello World!"
}

# 3.
Invoke-RunspacePool -ThreadBlock $cmd `
                    -ThreadParams $args `
                    -Verbose

################################################################################

$servicesToStart = @(
        [PSCustomObject] @{
            Service  = 'Service1'; Computer = 'Computer1'
        }
        [PSCustomObject] @{
            Service  = 'Service2'; Computer = 'Computer1'
        }
        [PSCustomObject] @{
            Service  = 'Service1'; Computer = 'Computer2'
        }
)

$workQ = [System.Collections.Queue]::Synchronized(
        (New-Object System.Collections.Queue( , $servicesToStart))
)

$cmd = {
    param ($q)
    
    while ($True) {
        try {
            $svc = $q.Dequeue()
        }
        catch {
            break
        }
        Get-Service -Name $svc.Service -ComputerName $svc.Computer `
        | Set-Service -Status Running
    }
}

$args = @{
    q  = $workQ
}

Invoke-RunspacePool $cmd $args