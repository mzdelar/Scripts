# 1. Check if the task is running and stop it
$taskName = "Process_Monitor"
$runningTask = Get-ScheduledTask | Where-Object { $_.TaskName -eq $taskName -and $_.State -eq "Running" }

if ($runningTask) {
    Stop-ScheduledTask -TaskName $taskName
}

# 2. Delete the Task Scheduler task
Unregister-ScheduledTask -TaskName $taskName -Confirm:$false

# 3. Set execution policy to Restricted
Set-ExecutionPolicy Restricted -Scope LocalMachine

# 4. Delete log file and script
Remove-Item -Path "C:\temp\process_log.txt" -Force
Remove-Item -Path "c:\temp\process_monitor.ps1" -Force

# 5. Delete environment variable
[Environment]::SetEnvironmentVariable("targetIP", $null, [System.EnvironmentVariableTarget]::Machine)

Write-Host "Tasks completed."
