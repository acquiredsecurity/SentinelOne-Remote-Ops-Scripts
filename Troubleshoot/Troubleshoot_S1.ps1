# Define paths
$destination = "C:\S1"
$zipFile = "C:\S1.zip"
$logFile = "$destination\log.txt"

# Ensure the destination directory exists
if (!(Test-Path -Path $destination)) {
    New-Item -ItemType Directory -Path $destination -Force
}

# Initialize log file
"Log of copied files - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File -FilePath $logFile -Force

# Define source paths (including wildcard path)
$sourcePaths = @(
    "C:\ProgramData\Sentinel\Crash Dumps",
    "C:\ProgramData\Sentinel\Logs",
    "C:\ProgramData\Sentinel\UserCrashDumps",
    "C:\memory.dmp",
    "C:\SentinelCrashes"
)

# Collect SentinelOne logs using wildcard
$sentinelOnePaths = Get-ChildItem -Path "C:\Program Files\SentinelOne\" -Directory -Filter "Sentinel Agent *" |
    ForEach-Object { Join-Path -Path $_.FullName -ChildPath "Logs" }

# Add wildcard-matched paths to the list
$sourcePaths += $sentinelOnePaths

# Loop through each source path and copy files
foreach ($source in $sourcePaths) {
    if (Test-Path -Path $source) {
        # Define destination path within S1 folder
        $destPath = Join-Path -Path $destination -ChildPath (Split-Path -Leaf $source)
        if (!(Test-Path -Path $destPath)) {
            New-Item -ItemType Directory -Path $destPath -Force
        }

        # Copy files and directories recursively
        Copy-Item -Path $source -Destination $destPath -Recurse -Force

        # Log copied files
        Get-ChildItem -Path $source -Recurse | ForEach-Object { $_.FullName } | Out-File -Append -FilePath $logFile
    } else {
        Write-Host "Warning: $source does not exist."
        "Warning: $source does not exist." | Out-File -Append -FilePath $logFile
    }
}

# Zip the S1 folder
if (Test-Path -Path $destination) {
    if (Test-Path -Path $zipFile) {
        Remove-Item -Path $zipFile -Force
    }

    Compress-Archive -Path "$destination\*" -DestinationPath $zipFile -Force
    Write-Host "Files successfully copied and zipped to $zipFile"
    "Files successfully copied and zipped to $zipFile" | Out-File -Append -FilePath $logFile
} else {
    Write-Host "No files copied, skipping zip process."
    "No files copied, skipping zip process." | Out-File -Append -FilePath $logFile
}

Write-Host "Log file created at $logFile"
