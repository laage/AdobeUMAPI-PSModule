<#
.SYNOPSIS
    Creates an array of requests that, when considered together, removes all users that are not admins, and not part of any user groups

.PARAMETER ClientInformation
    Service account information including token
  
.EXAMPLE
    Create-RemoveUnusedAbobeUsersRequest -ClientInformation $MyClientInfo
#>
function Create-RemoveUnusedAbobeUsersRequest
{
    Param
    (
        [ValidateScript({$_.Token -ne $null})]
        [Parameter(Mandatory=$true)]$ClientInformation
    )
    $AdobeUsers = Get-AdobeUsers -ClientInformation $ClientInformation
    $Requests = @()
    foreach ($User in $AdobeUsers)
    {
        if (($User.groups -eq $null -or $User.groups.length -eq 0) -and 
            ($User.adminRoles -eq $null -or $User.adminRoles.length -eq 0))
        {
            #Account not used
            $Requests+=Create-RemoveUserRequest -UserName $User.username
        }
    }
    return $Requests
}
