<#

Script to input 40-Man roster csv downloaded from www.baseball-reference.com and output a reformatted csv to easily upload users to Active Directory.
    -Foreign Language characters replaced
    -Uniform Number
    -First Name
    -Last Name
    -Full Name
    -SamAccountName
    -Position
    -AD Password

#>

# Prompt user to enter CSV path and File name.
$path = Read-Host "Please enter CSV File path\name"

# Import CSV file
$file = Import-csv $path 

# Array of characters in CSV to be altered
$chararray = 'Ã³','Ã©','Ã¡','Ãº','Ã±','Ã­','\.','\-',"'"

# Function to generate random passwords by size defined on input
function Get-RandomPassword {
    param (
        [Parameter(Mandatory)]
        [int] $length
    ) 
    $charSet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#!&$'.ToCharArray()
    $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $bytes = New-Object byte[]($length)
 
    $rng.GetBytes($bytes)
 
    $result = New-Object char[]($length)
 
    for ($i = 0 ; $i -lt $length ; $i++) {
        $result[$i] = $charSet[$bytes[$i]%$charSet.Length]
    }
 
    return (-join $result)
}


# Replace all characters in $chararry with characters defined below.
$file | ForEach-Object { 
        If ($_.name -match ($chararray -join '|')) 
        
            { 

            $_.name = $_.name -replace 'Ã³','o' -replace 'Ã©','e' -replace 'Ã¡','a' -replace 'Ãº','u' -replace 'Ã±','n' -replace 'Ã­','i' -replace '\.', '' -replace '\-','' -replace "'",""

            } 
        
        }

# Reformat CSV for easily defined objects to upload into Active Directory
$file | Foreach {

    $firstname = $_.name.split(" ")[0]
    $lastname = $_.name.split(" ")[1]
    $_.uni = "Uniform Number " + $_.uni 
    $samaccount = $firstname.Substring(0,1) + $lastname
    $samaccount = $samaccount.ToLower()
    $password = Get-RandomPassword 20

    $_ | Add-Member -MemberType NoteProperty -Name FirstName -Value $firstname
    $_ | Add-Member -MemberType NoteProperty -Name LastName -Value $lastname
    $_ | Add-Member -MemberType NoteProperty -Name SamAccount -Value $samaccount
    $_ | Add-Member -MemberType NoteProperty -Name Password -Value $password

    }

# Output new formatted CSV file to path indicated by user
$path = $path -replace '.csv', ''

$file | select Uni,FirstName,Lastname,Name,SamAccount,H2,Password | Export-Csv $path'_formatted.csv'
        

