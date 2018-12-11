<#
.SYNOPSIS
    Grab all members of the specified group

.PARAMETER ClientInformation 
    Your ClientInformation object

.PARAMETER UM_Server 
    The adobe user management uri. Defaults to "https://usermanagement.adobe.io/v2/usermanagement/"

.PARAMETER GroupID
    The ID of the group to query

.NOTES
    https://www.adobe.io/apis/cloudplatform/usermanagement/docs/samples/samplequery.html
  
.EXAMPLE
    Get-AdobeGroupMembers -ClientInformation $MyClient -GroupID "222424"
#>
function Get-AdobeGroupMembers
{
    Param
    (
        [string]$UM_Server="https://usermanagement.adobe.io/v2/usermanagement/",
        [ValidateScript({$_.Token -ne $null})]
        [Parameter(Mandatory=$true)]$ClientInformation, 
        [Parameter(Mandatory=$true)][string]$GroupID
    )
    #See https://www.adobe.io/apis/cloudplatform/usermanagement/docs/samples/samplequery.html
    $Results = @()

    $URIPrefix = "$UM_SERVER$($ClientInformation.OrgID)/user-groups/$GroupID/users?page="
    $Page =0

    #Request headers
    $Headers = @{Accept="application/json";
             "Content-Type"="application/json";
             "x-api-key"=$ClientInformation.APIKey;
             Authorization="Bearer $($ClientInformation.Token.access_token)"}

    while($true)
    {
        $QueryResponse = Invoke-RestMethod -Method Get -Uri ($URIPrefix) -Header $Headers
        if ($Results -ne $null -and $Results.id.Contains($QueryResponse[0].id))
        {
            break; #Why you ask? Because Adobe will just return any results they can anyway! If you have 1 page of results, and you ask for page 4, do they error? Noooo. Do they say last page? Nooo!
        }
        $Results += $QueryResponse
        $Page++;
        if ($QueryResponse.lastPage -eq $true -or $QueryResponse -eq $null -or $QueryResponse.Length -eq 0)
        {
            break
        }
    }
    return $Results
}
