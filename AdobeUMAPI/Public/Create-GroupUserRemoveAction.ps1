<#
.SYNOPSIS
    Creates a "Remove from group" action. Actions fall under requests. This will have to be added to a request, then json'd and submitted to adobe's API

.PARAMETER Groups
    An array of groups that something should be removed from

.NOTES
    See https://www.adobe.io/apis/cloudplatform/usermanagement/docs/samples/samplemultiaction.html
    This should be posted to https://usermanagement.adobe.io/v2/usermanagement/action/{myOrgID}
  
.EXAMPLE
    Create-GroupUserRemoveAction -Groups "My User Group"
#>
function Create-GroupUserRemoveAction
{
    Param
    (
        [Parameter(Mandatory=$true)]$Groups
    )

    $Params = New-Object -TypeName PSObject -Property @{usergroup=@()+$Groups}

    return (New-Object -TypeName PSObject -Property @{remove=$Params})
}
