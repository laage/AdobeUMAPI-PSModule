﻿<#
.SYNOPSIS
    Creates a "Add user to group" request. This will need to be json'd and sent to adobe

.PARAMETER Groups
    An array of groups that something should be added to

.NOTES
    See https://www.adobe.io/apis/cloudplatform/usermanagement/docs/samples/samplemultiaction.html
    This should be posted to https://usermanagement.adobe.io/v2/usermanagement/action/{myOrgID}
  
.EXAMPLE
    Create-AddToGroupRequest -Groups "My User Group" -User "John.Doe@domain.com"
#>
function Create-AddToGroupRequest
{
    Param
    (
        [Parameter(Mandatory=$true)][string]$User, 
        [Parameter(Mandatory=$true)]$Groups
    )
    $GroupAddAction = Create-GroupUserAddAction -GroupNames $Groups
    return return (New-Object -TypeName PSObject -Property @{user=$User;do=@()+$GroupAddAction})
}
