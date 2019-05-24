<#
.SYNOPSIS
    Lab 34343.334
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

CLS
Write-Host "Hi, Im about to start my scripting class. Armando Linang Jr. #761889"

Set-location $PSscriptRoot
$PromptString = @"
`n
Choose The following Options:
1 -> List/Export Log Files
2 -> List/Export All Files
3 -> List RAM/Proc Counters
4 -> List Processes
5 -> Exit
`nSelect
"@

$q = 0

Try { 
    while ($q -eq 0) {

        do { $UserIn = Read-Host -Prompt $PromptString }
    
        while (($Userin -notin "1", "2", "3", "4", "5"))

        switch ($UserIn) {

            # get-childitem then uses where-object to match all files names that contain.log (REGEX)
            # Outputs the result with a file name prepended with the $now variable. 
            # $now variable contains current timestamp
            "1" {
                "You selected 1!"
                get-date
                $now = Get-date -f "MM.dd.yy.hh.mm.ss"
                $list = 
                Get-ChildItem | ? { $_.name -match "\.log" } | select -expand name
                $list | out-file ".\$now-DailyLog.txt"
                $list
            }

            # Lists all the files and returns only 3 properties in the result. Uses sort-object to sort the rows. 
            "2" {
                "You selected 2!"

                $res = get-childItem | select name, length, lastwritetime | SOrt-object Name | ft
                $res | Out-file ".\C916contents.txt"
                $res
            }

            # Saves both results in an array. Uses custom object to convert the returned values. 
            "3" {
                Write-Host "You selected 3"

                write-host "Please wait . . ."
                $ResultObj = @()
                $ResultObj += Get-Counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 5 -MaxSamples 4 | select TimeStamp, @{Name = "Value"; E = { "{0:N0}" -f ($_.CounterSamples.Cookedvalue) } }, @{Name = "Counter"; E = { "ProcessorTime" } }
                $ResultObj += Get-Counter "\Memory\Available MBytes" -maxsamples 4 -sampleinterval 5 | select TimeStamp, @{ Name = "Value"; E = { "{0:N0}" -f ($_.countersamples.cookedvalue) } }, @{Name = "Counter"; E = { "AvailableMemory(MB)" } }
                Write-Output $ResultObj | ft
            }

            # task is vaguely defined. But I'm using TotalProcessorTime property. 
            "4" {   
                Write-Host "You selected 4"
                get-process | select Name, TotalProcessorTime | Sort-Object -Property TotalProcessorTime -Descending | Out-GridView
            }

            # quits
            "5" {
                $q = 1
                write-host "Exiting. . ."
            }     
        }
    }
}

# catches if the main functions fail and shows the error message
Catch { 
    Write-Host "An error occured in the main function"
    $error[0].Exception.Message
}






