Function CompareUserADGroups ($a, $b) {
    
    $ag = Get-ADPrincipalGroupMembership $a
    $bg = Get-ADPrincipalGroupMembership $b
    
    $cc = Compare-Object -ReferenceObject $ag.name -DifferenceObject $bg.name

    Write-Host "`n"
    Write-Host "Groups $user1 is a member of that $user2 is not"
    
    $cc | ForEach-Object {
        
        If ($_ -match "<=") 
                {
                    Write-Host "   "$_.inputobject
                }
        }

    Write-Host "`n"
    Write-Host "Groups $user2 is a member of that $user1 is not"
    
    $cc | ForEach-Object {
        
        If ($_ -match "=>") 
                {             
                    Write-Host "   "$_.inputobject
                }
        }

    }

$user1 = Read-Host "Please enter samaccount of First User"

$user2 = Read-Host "Please enter samaccount of Second User"

CompareUserADGroups -a $user1 -b $user2


        
    