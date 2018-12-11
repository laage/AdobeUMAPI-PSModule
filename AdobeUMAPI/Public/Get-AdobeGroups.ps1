<#
.SYNOPSIS
    Grab a list of all groups, or if provided an ID, returns the group related to the ID

.PARAMETER ClientInformation 
    Your ClientInformation object

.PARAMETER UM_Server 
    The adobe user management uri. Defaults to "https://usermanagement.adobe.io/v2/usermanagement/"

.PARAMETER GroupID
    If you wish to query for a single group instead, put the group ID here

.NOTES
    https://www.adobe.io/apis/cloudplatform/usermanagement/docs/samples/samplequery.html
  
.EXAMPLE
    Get-AdobeGroups -ClientInformation $MyClient

.EXAMPLE
    Get-AdobeGroups -ClientInformation $MyClient -GroupID "222242"
#>
function Get-AdobeGroups
{
    Param
    (
        [string]$UM_Server="https://usermanagement.adobe.io/v2/usermanagement/",
        $GroupID=$null,
        [ValidateScript({$_.Token -ne $null})]
        [Parameter(Mandatory=$true)]$ClientInformation
    )
    #See https://www.adobe.io/apis/cloudplatform/usermanagement/docs/samples/samplequery.html
    $Results = @()
    if ($GroupID -eq $null)
    {
        $URIPrefix = "$UM_SERVER$($ClientInformation.OrgID)/user-groups?page="
    }
    else
    {
        $URIPrefix = "$UM_SERVER$($ClientInformation.OrgID)/user-groups/$GroupID"
    }
    $Page =0

    #Request headers
    $Headers = @{Accept="application/json";
             "Content-Type"="application/json";
             "x-api-key"=$ClientInformation.APIKey;
             Authorization="Bearer $($ClientInformation.Token.access_token)"}
    if ($GroupID -eq $null)
    {
        while($true)
        {
            $QueryResponse = Invoke-RestMethod -Method Get -Uri ($URIPrefix+$Page.ToString()) -Header $Headers
            if ($Results -ne $null -and $Results.groupId.Contains($QueryResponse[0].groupId))
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
    }
    else
    {
        $Results = Invoke-RestMethod -Method Get -Uri $URIPrefix -Header $Headers
    }
    return $Results
}
