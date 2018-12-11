<#
.SYNOPSIS
    Creates a "RemoveUserRequest" object. This object can then be converted to JSON and sent to remove a user frin adibe

.PARAMETER UserName
    User's ID, usually e-mail

.PARAMETER AdditionalActions
    An array of additional actions to add to the request. (Like add to group)

.NOTES
    See https://www.adobe.io/apis/cloudplatform/usermanagement/docs/samples/samplemultiaction.html
    This should be posted to https://usermanagement.adobe.io/v2/usermanagement/action/{myOrgID}
  
.EXAMPLE
    Create-RemoveUserRequest -UserName "john.doe@domain.com"
#>
function Create-RemoveUserRequest
{
    Param
    (
        [Parameter(Mandatory=$true)][string]$UserName, 
        $AdditionalActions=@()
    )

    $RemoveAction = New-Object -TypeName PSObject -Property @{removeFromOrg=(New-Object -TypeName PSObject)}

    $AdditionalActions = @() + $RemoveAction + $AdditionalActions

    return (New-Object -TypeName PSObject -Property @{user=$UserName;do=@()+$AdditionalActions})
}
