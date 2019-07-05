## ---- [Script Parameters] ----
Param()


# Function Cleanup-Logs - clean up the log folder
function Cleanup-Logs
{
    <#
    .SYNOPSIS
        Using the retention days, clear down the log folder
    .DESCRIPTION
        Using the calculated retention date, remove items from the log folder
    .EXAMPLE
        Cleanup-Logs
    .OUTPUTS
        Folder with fewer items in it
    .NOTES
        Version:        1.0
        Author:         Dean Smith | deanwsmith@outlook.com
        Creation Date:  2019-07-05
        Purpose/Change: Initial script creation
    #>
    ## ---- [Function Parameters] ----
    [CmdletBinding()]
    Param()

    ## ---- [Function Beginning] ----
    Begin {}

    ## ---- [Function Execution] ----
    Process
    {
        # For the Log Folder, remove items older than retention days
        $LogFolderItems = Get-ChildItem -Path $LogFolder | Where-Object { $_.LastWriteTime -lt $DeletionDate }
        $LogFolderItemCount = $LogFolderItems.Count
        $LogFolderItems | Remove-Item

        # Write out the details to the transcript
        $Timestamp = Get-Date -UFormat "%T"
        $LogMessage = ("`r`n$TimeStamp`t${JobName}`tCleanup-Logs")
        $LogMessage = $LogMessage + ("`nLog Folder: "+ $LogFolderItemCount + " Items Removed")
        Write-Output ($LogMessage)
    }

    ## ---- [Function End] ----
    End {}
}


<#
.SYNOPSIS
    Automatically tidy up log files
.DESCRIPTION
    Remove all log files older than retention days
.EXAMPLE
    .\CleanupLogs.ps1
.NOTES
    Version:        1.0
    Author:         Dean Smith | deanwsmith@outlook.com
    Creation Date:  2019-07-05
    Purpose/Change: Initial script creation
#>

## ---- [Execution] ----

# Set the start date (which is today)
$DateStart = (Get-Date -Format "yyyy-MM-dd")

# Load configuration details and set up job and log details
$ConfigurationFile = ".\CleanupLogs.xml"
If (Test-Path $ConfigurationFile)
{
	Try
	{
        $Job = New-Object xml
        $Job.Load("$ConfigurationFile")
		$JobFolder = $Job.Configuration.JobFolder
		$JobName = $Job.Configuration.JobName
		$LogFolder = $Job.Configuration.LogFolder
        $JobDate = (Get-Date -Format FileDateTime)
        $LogFile = ("$LogFolder\${JobName}-$JobDate.log")
        $RetentionDays = $Job.Configuration.RetentionDays
        $DeletionDate = Get-Date((Get-Date($DateStart)).AddDays($RetentionDays)) -Format "dd-MMM-yyyy"
	}
	Catch [system.exception]
    {
        Write-Output "Caught Exception: $($Error[0].Exception.Message)"
    }
}

# Start Transcript
Start-Transcript -Path $Logfile -NoClobber -Verbose -IncludeInvocationHeader
$Timestamp = Get-Date -UFormat "%T"
$LogMessage = ("-" * 79 + "`r`n$Timestamp`t${JobName}: Starting Transcript`r`n" + "-" * 79)
$LogMessage = $LogMessage + ("`r`n`r`n$TimeStamp`t${JobName}`nDelete:`t`t$DeletionDate")
Write-Output $LogMessage

# Call functions in order to clean up log files
Cleanup-Logs

## Stop Transcript
$Timestamp = Get-Date -UFormat "%T"
$LogMessage = ("`r`n" + "-" * 79 + "`r`n$Timestamp`t${JobName}: Stopping Transcript`r`n" + "-" * 79)
Write-Output $LogMessage
Stop-Transcript