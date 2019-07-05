# CleanupLogs

A PowerShell script that will remove log entries older than a user defined retention date.

This script is expected to be run on a nightly schedule after any other scheduled jobs.


## Features

The Cleanup Logs PowerShell script uses a configuration file to allow easy management of your personal settings plus the retention days of your choice.

The Cleanup Logs PowerShell script will:

* Identify the folders containing log files
* Remove log file entries older than a specified retention date
* Write results to a log file for analysis


## Prerequisites

To install the script on your system you will need the following information:

* A script location for your PowerShell scripts (e.g. `"C:\Tools\Scripts"` or `"D:\ServerFolders\Company\Scripts"`)
* A folder for log files  (e.g. `"C:\Tools\Scripts\Logs"` or `"D:\ServerFolders\Company\Scripts\Logs"`)


## Installation

A simple clone of the repository is all that is required:

* On the [GitHub page for this repository](https://github.com/instantdreams/CleanupLogs) select "Clone or Download" and copy the web URL
* Open your GIT Bash of choice and enter the following commands:
	* cd {base location of your scripts folder}
	* git clone {repository url}
* For example, assuming your script location is D:\ServerFolders\Company\Scripts, use the following:
    * `cd /d/ServerFolders/Company/Scripts`
	* `git clone https://github.com/instantdreams/CleanupLogs.git`

This will install a copy of the scripts and files in the folder "CleanupLogs" under your script location.


## Configuration

Minor configuration is required before running the script:

* Open File Explorer and navigate to your script location
* Copy file "CleanupLogs-Sample.xml" and rename the result to "CleanupLogs.xml"
* Edit the file with your favourite text or xml editor
	* For JobFolder enter the full path to the script folder (e.g. "C:\Tools\Scripts\CleanupLogs")
	* For LogFolder enter the full path to the log folder (e.g. "C:\Tools\Scripts\Logs")
	* The retention days should be a negative number, which is used to calculate the number of days before the start date to remove files
* Save the file and exit the editor


## Running

To run the script, open a PowerShell window and use the following commands:
```
Set-Location -Path "D:\ServerFolders\Company\Scripts\CleanupLogs"
Push-Location -Path "D:\ServerFolders\Company\Scripts\CleanupLogs"
[Environment]::CurrentDirectory = $PWD
.\CleanupLogs.ps1
```

This will attempt to clean up the log folders and create a log file with the standard name.


## Scheduling

This script was designed to run as a scheduled task to remove log files older than a certain date. With Windows or Windows Server, the easiest way of doing this is to use Task Scheduler.

1. Start Task Scheduler
2. Select Task Scheduler Library
3. Right click and select Create Task
4. Use the following entries:
  * General
    * Name:			CleanupLogs
    * Description:	Clean up log files older than retention days
    * Account:		Use your script execution account
    * Run whether user is logged on or not
    * Run with highest privileges
  * Triggers
    * Daily
    * Start at:		07:00
    * Recur every:	1 day
    * Enable
  * Actions
    * Action:		Start a program
    * Program:		PowerShell
    * Arguments:	-ExecutionPolicy Bypass -NoLogo -NonInteractive -File "{script location}\CleaupupLogs\CleanupLogs.ps1"
    * Start in:		{script location}\CleanupLogs
  * Settings
    * Allow task to be run on demand
    * Stop the task if it runs longer than: 1 day

Adjust the arguments as needed to run after your existing scheduled jobs.


## Troubleshooting

Please review the log files located in the log folder to determine any issues.


## Author

* **Dean W. Smith** - *Script Creation* - [instantdreams](https://github.com/instantdreams)


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details


## Security

This project has a security policy - see the [SECURITY.md](SECURITY.md) file for details