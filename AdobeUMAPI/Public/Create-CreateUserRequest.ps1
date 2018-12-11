<#
.SYNOPSIS
    Creates a "CreateUserRequest" object. This object can then be converted to JSON and sent to create a new user

.PARAMETER FirstName
    User's First name

.PARAMETER LastName
    User's Last Name

.PARAMETER Email
    User's Email and ID

.PARAMETER Country
    Defaults to US. This cannot be changed later. (Per adobe documentation)

.PARAMETER AdditionalActions
    An array of additional actions to add to the request. (Like add to group)

.NOTES
    See https://www.adobe.io/apis/cloudplatform/usermanagement/docs/samples/samplemultiaction.html
    This should be posted to https://usermanagement.adobe.io/v2/usermanagement/action/{myOrgID}
  
.EXAMPLE
    Create-CreateUserRequest -FirstName "John" -LastName "Doe" -Email "John.Doe@domain.com"
#>
function Create-CreateUserRequest
{
    Param
    (
        [Parameter(Mandatory=$true)][string]$FirstName, 
        [Parameter(Mandatory=$true)][string]$LastName, 
        [Parameter(Mandatory=$true)][string]$Email, 
        [string]$Country="US", 
        $AdditionalActions=@()
    )

    #Parameters to create a new enterprise ID
    $EnterpriseIDParameters = New-Object -TypeName PSObject -Property @{email=$Email;country=$Country;firstname=$FirstName;lastname=$LastName}

    #Enterprise ID creation action
    $EnterpriseIDAction = New-Object -TypeName PSObject -Property @{createEnterpriseID=$EnterpriseIDParameters}

    #Add any additional actions
    $AdditionalActions = @()+ $EnterpriseIDAction + $AdditionalActions

    #Return the new request
    return (New-Object -TypeName PSObject -Property @{user=$Email;do=@()+$AdditionalActions})
}
