SentinelOne Logs and Files Collection Script

This PowerShell script automates the process of collecting and archiving key SentinelOne logs and system files for analysis. It performs the following tasks:

Defines source directories for SentinelOne-related logs, crash dumps, and other relevant system files, including:

C:\ProgramData\Sentinel\Crash Dumps: Contains SentinelOne crash dumps.
C:\ProgramData\Sentinel\Logs: Stores SentinelOne logs.
C:\ProgramData\Sentinel\UserCrashDumps: Contains user-generated crash dumps related to SentinelOne.
C:\memory.dmp: The system memory dump, useful for debugging.
C:\SentinelCrashes: Contains additional SentinelOne crash-related data.
*C:\Program Files\SentinelOne\Sentinel Agent \Logs: Logs from SentinelOne agent directories, including wildcarded agent version directories (e.g., Sentinel Agent 1.0.0).
Creates a destination directory (C:\S1) to store the collected files, ensuring it exists before proceeding.

Copies the relevant files from the specified paths and subdirectories to the destination folder, logging each copied item to a log file located at C:\S1\log.txt.

Zips the collected files into an archive (C:\S1.zip), making the data easy to store and transfer. Use the S1 console to collect this path back to the cloud console.

Logs any warnings for missing source paths and documents the copied files in a log file for transparency.

This script is designed for use in troubleshooting, forensic analysis, or archiving SentinelOne-related data from Windows systems.
