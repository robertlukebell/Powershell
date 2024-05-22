
# Script to check AD for all Computers with 7 days or more of uptime and output hostnames in HTML file

$proc = Get-ADComputer -Filter * | ForEach-Object {

    $a = (get-date)-(gcim Win32_OperatingSystem).LastBootUpTime
    $d = $a.Days.tostring()

    If ($a.days -ge 7)
        {
            [PSCustomObject]@{
            'Host Name' = $_.name 
            'Uptime' = $d + ' days'
            }
        }
    }

$proc | ConvertTo-Html -Property "Host Name","Uptime" | Out-File -FilePath "c:\temp\file.html"


