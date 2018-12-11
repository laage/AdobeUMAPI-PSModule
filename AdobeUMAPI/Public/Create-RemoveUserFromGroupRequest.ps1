<#
.SYNOPSIS
    Creates a request to remove a user from an Adobe group. This will need to be posted after being converted to a JSON

.PARAMETER UserName
    User's ID, usually e-mail

.PARAMETER GroupName
    Name of the group to remove the user from

.NOTES
    See https://www.adobe.io/apis/cloudplatform/usermanagement/docs/samples/samplemultiaction.html
    This should be posted to https://usermanagement.adobe.io/v2/usermanagement/action/{myOrgID}
  
.EXAMPLE
    Create-RemoveUserFromGroupRequest -UserName "john.doe@domain.com" -GroupName "My User Group"
#>
function Create-RemoveUserFromGroupRequest
{
    Param
    (
        [Parameter(Mandatory=$true)][string]$UserName,
        [Parameter(Mandatory=$true)]$GroupName
    )

    $RemoveMemberAction = Create-GroupUserRemoveAction -Groups $GroupName

    return (New-Object -TypeName PSObject -Property @{user=$UserName;do=@()+$RemoveMemberAction})
}
