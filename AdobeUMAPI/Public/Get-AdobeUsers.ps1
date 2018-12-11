<#
.SYNOPSIS
    Gets all users from the adobe API

.PARAMETER ClientInformation 
    Your ClientInformation object

.PARAMETER UM_Server 
    The adobe user management uri. Defaults to "https://usermanagement.adobe.io/v2/usermanagement/"

.NOTES
    https://www.adobe.io/apis/cloudplatform/usermanagement/docs/samples/samplequery.html
  
.EXAMPLE
    Get-AdobeUsers -ClientInformation $MyClient
#>
function Get-AdobeUsers
{
    Param
    (
        [string]$UM_Server="https://usermanagement.adobe.io/v2/usermanagement/", 
        [ValidateScript({$_.Token -ne $null})]
        [Parameter(Mandatory=$true)]$ClientInformation
    )
    #Store the results here
    $Results = @()

    #URI of the query endpoint
    $URIPrefix = "$UM_Server$($ClientInformation.OrgID)/users?page="
    $Page =0

    #Request headers
    $Headers = @{Accept="application/json";
             "Content-Type"="application/json";
             "x-api-key"=$ClientInformation.APIKey;
             Authorization="Bearer $($ClientInformation.Token.access_token)"}
    #Query, looping through each page, until we have all users.
    while($true)
    {
        $QueryResponse = Invoke-RestMethod -Method Get -Uri ($URIPrefix+$Page.ToString()) -Header $Headers
        #Currently not required, but other queries will just keep dumping the same users as you loop though pages
        if ($Results -ne $null -and $Results.id.Contains($QueryResponse[0].id))
        {
            break;
        }
        $Results += $QueryResponse
        $Page++;
        #Different API endpoints have different ways of telling you if you are done.
        if ($QueryResponse.lastPage -eq $true -or $QueryResponse -eq $null -or $QueryResponse.Length -eq 0)
        {
            break; 
        }
    }
    return $Results
}
