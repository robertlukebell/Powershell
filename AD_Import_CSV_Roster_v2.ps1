
<#

Script to create AD User Accounts from formatted CSV Roster file created with CSV_Roster_Reformat.ps1

Team Context provided via MLB_Team_Details.xml

#>

# Get XML Team File Content
[XML]$teamxml = Get-Content .\MLB_Team_Details.xml

# Prompt user to enter CSV path and file name.
$path = Read-Host "Please enter CSV File path\name"

# Import CSV file
$file = Import-csv $path 

# Prompt user to select team OU to upload CSV to
$tname = Read-Host "Please select Team Name of Roster to Upload (Remove spaces)"   

# Parse through CSV file and create AD User accounts for each object. If SamAccountName already exists, increment by 1 until nonexistent SamAccountName is reached
$file | ForEach-Object { 

    $i = 0

    While ((Get-aduser $_.samaccount) -ne $null) {

        $i++
        $_.samaccount = ($_.samaccount -replace '\d+','') + $i

        }

    $_.password = $_.password | ConvertTo-SecureString -AsPlainText -Force

    new-aduser -Enabled $true -Name $_.name -GivenName $_.firstname -Surname $_.lastname -DisplayName $_.name -SamAccountName $_.samaccount -UserPrincipalName $_.samaccount -AccountPassword $_.password -Description $_.uni -Office $teamxml.teams.$tname.city -Title $_.h2 -Department $teamxml.teams.$tname.league -Company $teamxml.teams.$tname.fullname -StreetAddress $teamxml.teams.$tname.street -City $teamxml.teams.$tname.postalcity -State $teamxml.teams.$tname.state -PostalCode $teamxml.teams.$tname.zip -Path $teamxml.teams.$tname.ou -Manager $teamxml.teams.$tname.manager

    }