<#
.SYNOPSIS
    Creates an object to contain client information such as service account details.

.PARAMETER APIKey 
    Your service account's APIkey/ClientID as returned by https://console.adobe.io/

.PARAMETER OrganizationID 
    Your OrganizationID as returned by https://console.adobe.io/

.PARAMETER ClientSecret 
    Your service account's ClientSecret  as returned by https://console.adobe.io/

.PARAMETER TechnicalAccountID 
    Your service account's TechnicalAccountID  as returned by https://console.adobe.io/

.PARAMETER TechnicalAccountEmail 
    Your service account's TechnicalAccountEmail  as returned by https://console.adobe.io/

.OUTPUTS
    ClientInformation object to be passed to further commands
  
.EXAMPLE
    New-ClientInformation -APIKey "1111111111111222222333" -OrganizationID "22222222222222@AdobeOrg" -ClientSecret "xxxx-xxxx-xxxx-xxxx" -TechnicalAccountID "abcdf@techacct.adobe.com" -TechnicalAccountEmail "xxxx-xxxx-xxxx-xxxx@techacct.adobe.com"
#>
function New-ClientInformation
{
    Param
    (
        [Parameter(Mandatory=$true)][string]$APIKey, 
        [Parameter(Mandatory=$true)][string]$OrganizationID, 
        [Parameter(Mandatory=$true)][string]$ClientSecret, 
        [Parameter(Mandatory=$true)][string]$TechnicalAccountID, 
        [Parameter(Mandatory=$true)][string]$TechnicalAccountEmail
    )
    return New-Object -TypeName PSObject -ArgumentList @{
        APIKey = $APIKey; # ClientID
        ClientID = $APIKey; # Alias, adobe flip flops on what they call this
        OrgID = $OrganizationID;
        ClientSecret = $ClientSecret;
        TechnicalAccountID = $TechnicalAccountID;
        TechnicalAccountEmail = $TechnicalAccountEmail;
        Token=$null;
    }
}
