#Skipta za kreiranje process monitora kao task schedulera za pojedinu IP adresu

Write-Host "Ask for IP address and set an environmental variable"
$targetIP = Read-Host "Please enter IP address to monitor"
Write-Host "Set env variable..."
[Environment]::SetEnvironmentVariable('MonitorIPAddress', $targetIP, [System.EnvironmentVariableTarget]::Machine)

Write-Host "Downloading the file"
$url = "https://raw.githubusercontent.com/mzdelar/Scripts/master/process_monitor.ps1"
$outputPath = "C:\temp\process_monitor.ps1"
Invoke-WebRequest -Uri $url -OutFile $outputPath

Write-Host "Check and set execution policy"
$executionPolicy = Get-ExecutionPolicy
if ($executionPolicy -eq "Restricted") {
    Set-ExecutionPolicy Unrestricted
}

Write-Host "Create a new Task Scheduler"
$TaskAction = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "C:\temp\process_monitor.ps1"
$TaskTrigger = New-ScheduledTaskTrigger -AtStartup
$TaskUser = Read-Host "Please enter the username for starting script:"
$TaskPassword = Read-Host "Please enter the password:" 


try {
Register-ScheduledTask -Action $TaskAction -Trigger $TaskTrigger -TaskName "Process_Monitor" -User $TaskUser -Password $TaskPassword -ErrorAction Stop

# If registration is successful, display a success message
Write-Host "Scheduled task Process_Monitor successfully created."

# Handle any errors
}  catch {
    Write-Host "Error: $($_.Exception.Message)"
    # You can add more error-handling code here if needed
	return
}

Start-Sleep -Seconds 2

Write-Host "Check if the task is running"
$taskStatus = Get-ScheduledTask -TaskName "Process_Monitor" | Select-Object -ExpandProperty State
if ($taskStatus -eq "Running") {
    Write-Host "The Process_Monitor task is running."
    # Perform actions when the task is running
} elseif ($taskStatus -eq "Ready") {
    Write-Host "The Process_Monitor task is ready and waiting to run."
	Start-ScheduledTask -TaskName "Process_Monitor"
	Write-Host "The Process_Monitor task started."
}

Write-Host "Script execution OK."




