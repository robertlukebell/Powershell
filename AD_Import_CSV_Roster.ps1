
<#

Script to create AD User Accounts from formatted CSV Roster file created with CSV_Roster_Reformat.ps1

#>


# Prompt user to enter CSV path and file name.
$path = Read-Host "Please enter CSV File path\name"

# Import CSV file
$file = Import-csv $path 

# Prompt user to select team OU to upload CSV to
$teamname = Read-Host "Please select Team Name of Roster to Upload

1.] Angels
2.] Astros
3.] Athletics
4.] Blue Jays
5.] Braves
6.] Brewers
7.] Cardinals
8.] Cubs
9.] Diamondbacks
10.] Dodgers
11.] Giants
12.] Guardians
13.] Mariners
14.] Marlins
15.] Mets
16.] Nationals
17.] Orioles
18.] Padres
19.] Phillies
20.] Pirates
21.] Rangers
22.] Rays
23.] Reds
24.] Red Sox
25.] Rockies
26.] Royals
27.] Tigers
28.] Twins
29.] White Sox
30.] Yankees

"   

# Table of predefinced Active Directory attributes based upon selected Team designation
$teamID = switch ($teamname) {

    '1' { @("Angels","Los Angeles","American League","Los Angeles Angels","2000 E Gene Autry Way","Anaheim","CA","92806","ou=angels,ou=west,ou=al,ou=mlb,dc=ad,dc=mlb,dc=lan","rwashington") }
    '2' { @("Astros","Houston","American League","Houston Astros","501 Crawford St","Houston","TX","77002","ou=astros,ou=west,ou=al,ou=mlb,dc=ad,dc=mlb,dc=lan","jespada") }
    '3' { @("Athletics","Oakland", "American League","Oakland Athletics","700 73rd Ave","Oakland","CA","94621","ou=athletics,ou=west,ou=al,ou=mlb,dc=ad,dc=mlb,dc=lan","mkotsay") }
    '4' { @("Blue Jays","Toronto","American League","Toronto Blue Jays","1 Blue Jays Way","Toronto","ON","M5V 1J1","ou=bluejays,ou=east,ou=al,ou=mlb,dc=ad,dc=mlb,dc=lan","jschneider") }
    '5' { @("Braves","Atlanta","National League","Atlanta Braves","755 Battery Ave. SE","Atlanta","GA","30339","ou=braves,ou=east,ou=nl,ou=mlb,dc=ad,dc=mlb,dc=lan","bsnitker") }
    '6' { @("Brewers","Milwaukee","National League","Milwaukee Brewers","One Brewers Way","Milwaukee","WI","53214","ou=brewers,ou=central,ou=nl,ou=mlb,dc=ad,dc=mlb,dc=lan","pmurphy") }
    '7' { @("Cardinals","St. Louis","National League","St. Louis Cardinals","700 Clark Ave","Saint Louis","MO","63102","ou=cardinals,ou=central,ou=nl,ou=mlb,dc=ad,dc=mlb,dc=lan","omarmol") }
    '8' { @("Cubs","Chicago","National League","Chicago Cubs","1060 W Addison St","Chicago","IL","60613","ou=cubs,ou=central,ou=nl,ou=mlb,dc=ad,dc=mlb,dc=lan","dross") }
    '9' { @("Diamondbacks","Arizona","National League","Arizona Diamondbacks","401 E Jefferson St","Phoenix","AZ","85004","ou=diamondbacks,ou=west,ou=nl,ou=mlb,dc=ad,dc=mlb,dc=lan","tlovullo") }
    '10' { @("Dodgers","Los Angeles","National League","Los Angeles Dodgers","1000 Elysian Park Ave","Los Angeles","CA","90012","ou=dodgers,ou=west,ou=nl,ou=mlb,dc=ad,dc=mlb,dc=lan","droberts") }
    '11' { @("Giants","San Francisco","National League","San Francisco Giants","24 Willie Mays Plz","San Francisco","CA","94107","ou=giants,ou=west,ou=nl,ou=mlb,dc=ad,dc=mlb,dc=lan","bmelvin") }
    '12' { @("Guardians","Cleveland","American League","Cleveland Guardians","2401 Ontario St","Cleveland","OH","44115","ou=guardians,ou=central,ou=al,ou=mlb,dc=ad,dc=mlb,dc=lan","svogt") }
    '13' { @("Mariners","Seattle","American League","Seattle Mariners","1250 1st Ave S","Seattle","WA","98134","ou=mariners,ou=west,ou=al,ou=mlb,dc=ad,dc=mlb,dc=lan","sservais") }
    '14' { @("Marlins","Miami","National League","Miami Marlins","501 Marlins Way","Miami","FL","33125","ou=marlins,ou=east,ou=nl,ou=mlb,dc=ad,dc=mlb,dc=lan","sschumaker") }
    '15' { @("Mets","New York","National League","New York Mets","123-01 Roosevelt Ave","Flushing","NY","11368","ou=mets,ou=east,ou=nl,ou=mlb,dc=ad,dc=mlb,dc=lan","cmendoza") }
    '16' { @("Nationals","Washington","National League","Washington Nationals","1500 S Capitol St SE","Washington","DC","20003","ou=nationals,ou=east,ou=nl,ou=mlb,dc=ad,dc=mlb,dc=lan","dmartinez") }
    '17' { @("Orioles","Baltimore","American League","Baltimore Orioles","333 W Camden St","Baltimore","MD","21201","ou=orioles,ou=east,ou=al,ou=mlb,dc=ad,dc=mlb,dc=lan","bhyde") }
    '18' { @("Padres","San Diego","National League","San Diego Padres","100 Park Blvd","San Diego","CA","92101","ou=padres,ou=west,ou=nl,ou=mlb,dc=ad,dc=mlb,dc=lan","mshildt") }
    '19' { @("Phillies","Philadelphia","National League","Philadelphia Phillies","1 Citizens Bank Way Ofc","Philadelphia","PA","19148","ou=phillies,ou=east,ou=nl,ou=mlb,dc=ad,dc=mlb,dc=lan","rthomson") }
    '20' { @("Pirates","Pittsburgh","National League","Pittsburgh Pirates","115 Federal St","Pittsburgh","PA","15212","ou=pirates,ou=central,ou=nl,ou=mlb,dc=ad,dc=mlb,dc=lan","dshelton") }
    '21' { @("Rangers","Texas","American League","Texas Rangers","734 Stadium Dr","Arlington","TX","76011","ou=rangers,ou=west,ou=al,ou=mlb,dc=ad,dc=mlb,dc=lan","bbochy") }
    '22' { @("Rays","Tampa Bay","American League","Tampa Bay Rays","1 Tropicana Dr","Saint Petersburg","FL","33705","ou=rays,ou=east,ou=al,ou=mlb,dc=ad,dc=mlb,dc=lan","kcash") }
    '23' { @("Reds","Cincinnati","National League","Cincinnati Reds","100 Joe Nuxhall Way","Cincinnati","OH","45202","ou=reds,ou=central,ou=nl,ou=mlb,dc=ad,dc=mlb,dc=lan","dbell") }
    '24' { @("Red Sox","Boston","American League","Boston Red Sox","4 Jersey St","Boston","MA","02215","ou=redsox,ou=east,ou=al,ou=mlb,dc=ad,dc=mlb,dc=lan","acora") }
    '25' { @("Rockies","Colorado","National League","Colorado Rockies","2001 Blake St","Denver","CO","80205","ou=rockies,ou=west,ou=nl,ou=mlb,dc=ad,dc=mlb,dc=lan","bblack") }
    '26' { @("Royals","Kansas City","American League","Kansas City Royals","1 Royal Way","Kansas City","MO","64129","ou=royals,ou=central,ou=al,ou=mlb,dc=ad,dc=mlb,dc=lan","mquatraro") }
    '27' { @("Tigers","Detroit","American League","Detroit Tigers","2100 Woodward Ave","Detroit","MI","48201","ou=tigers,ou=central,ou=al,ou=mlb,dc=ad,dc=mlb,dc=lan","ahinch") }
    '28' { @("Twins","Minnesota","American League","Minnesota Twins","1 Twins Way","Minneapolis","MN","55403","ou=twins,ou=central,ou=al,ou=mlb,dc=ad,dc=mlb,dc=lan","rbaldelli") }
    '29' { @("White Sox","Chicago","American League","Chicago White Sox","333 West 35th Street","Chicago","IL","60616","ou=whitesox,ou=central,ou=al,ou=mlb,dc=ad,dc=mlb,dc=lan","pgrifol") }
    '30' { @("Yankees","New York","American League","New York Yankees","1 E 161st St","Bronx","NY","10451","ou=yankees,ou=east,ou=al,ou=mlb,dc=ad,dc=mlb,dc=lan","aboone") }
    }

# Parse through CSV file and create AD User accounts for each object. If SamAccountName already exists, increment by 1 until nonexistent SamAccountName is reached
$file | ForEach-Object { 

    $i = 0

    While ((Get-aduser $_.samaccount) -ne $null) {

        $i++
        $_.samaccount = ($_.samaccount -replace '\d+','') + $i

        }

    $_.password = $_.password | ConvertTo-SecureString -AsPlainText -Force

    new-aduser -Enabled $true -Name $_.name -GivenName $_.firstname -Surname $_.lastname -DisplayName $_.name -SamAccountName $_.samaccount -UserPrincipalName $_.samaccount -AccountPassword $_.password -Description $_.uni -Office $teamID[1] -Title $_.h2 -Department $teamID[2] -Company $teamID[3] -StreetAddress $teamID[4] -City $teamID[5] -State $teamID[6] -PostalCode $teamID[7] -Path $teamID[8] -Manager $teamID[9]

    }