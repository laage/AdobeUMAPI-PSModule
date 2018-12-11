<#
.SYNOPSIS
    Creates an array of requests that, when considered together, ensures an Adobe group will mirror an AD group

.PARAMETER ADGroupID
    Active Directory Group Identifier. The source group to mirror to adobe

.PARAMETER AdobeGroupID
    Adobe group ID as retured from Get-AdobeGroups

.PARAMETER ClientInformation
    Service account information including token
  
.EXAMPLE
    Create-SyncADGroupRequest -ADGroupID "SG-My-Approved-Adobe-Users" -AdobeGroupID "111222422" -ClientInformation $MyClientInfo
#>
function Create-SyncADGroupRequest
{
    Param
    (
        [Parameter(Mandatory=$true)][string]$ADGroupID, 
        [Parameter(Mandatory=$true)][string]$AdobeGroupID, 
        [ValidateScript({$_.Token -ne $null})]
        [Parameter(Mandatory=$true)]$ClientInformation
    )
    #Grab a list of all adobe groups
    $AdobeGroupInfo = Get-AdobeGroups -GroupID $AdobeGroupID -ClientInformation $ClientInformation
    #Grab a list of users in the Active Directory group
    $ADGroupMembers = Get-ADGroupMember -Identity $ADGroupID | Where-Object -FilterScript {$_.ObjectClass -eq "user"}
    #Get extended property data on all users. (So we can get e-mail)
    $ADUsers = @()
    foreach ($ADGroupMember in $ADGroupMembers)
    {
        $ADUsers += Get-ADUser -Identity $ADGroupMember.distinguishedName -Properties mail
    }
    #Grab a list of users from the adobe group
    $Members = (Get-AdobeGroupMembers -ClientInformation $ClientInformation -GroupID $AdobeGroupID).username

    #Results
    $Request = @()

    #Find missing users, and create requests to add them to adobe
    foreach ($ADUser in $ADUsers)
    {
        #If adobe group does not contain ad user
        if ($Members.Length -le 0 -or -not $Members.Contains($ADUser.mail))
        {
            $AddToGroup = Create-GroupUserAddAction -Groups $AdobeGroupInfo.name
            #Need to add
            $Request += Create-CreateUserRequest -UserDisplayName $ADUser.mail -FirstName $ADUser.GivenName -LastName $ADUser.SurName -Email $ADUser.mail -Country "US" -AdditionalActions $AddToGroup
        }
    }
    #Find excess members and create requests to remove them
    foreach ($Member in $Members)
    {
        if (-not $ADUsers.mail.Contains($Member))
        {
            #Need to remove
            $Request += Create-RemoveUserFromGroupRequest -UserName $Member -GroupName $AdobeGroupInfo.name
        }
    }
    #return our list of requests
    return $Request
}
