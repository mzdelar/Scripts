
$logPath = "C:\temp\process_log.txt"

while ($true) {
    $connections = Get-NetTCPConnection | Where-Object { $_.RemoteAddress -eq $targetIP }

    if ($connections) {
        $connections | ForEach-Object {
            $process = Get-Process -Id $_.OwningProcess
            if ($process.ProcessName -ne "Idle") {
                $logEntry = "Date/Time: $(Get-Date -Format 'HH:mm:ss/dd/MM/yyyy')             Process_Name: $($process.ProcessName)           Process_ID: $($process.Id)          Remote_address: $($_.RemoteAddress)                Remote_Port: $($_.RemotePort)             Connection_State: $($_.State)"
                Add-Content -Path $logPath -Value $logEntry
            }
        }
    }

    Start-Sleep -Seconds 1 # Adjust the interval as needed
}

