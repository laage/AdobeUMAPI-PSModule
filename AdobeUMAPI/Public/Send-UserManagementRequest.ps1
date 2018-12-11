<#
.SYNOPSIS
    Sends a request, or array of requests, to adobe's user management endpoint

.PARAMETER ClientInformation
    ClientInformation object containing service account info and token

.PARAMETER Requests
    An array of requests to send to adobe

.NOTES
    See the Create-*Request
  
.EXAMPLE
    Send-UserManagementRequest -ClientInformation $MyClientInfo -Requests (Create-CreateUserRequest -FirstName "John" -LastName "Doe" -Email "john.doe@domain.com" -Country="US")
#>
function Send-UserManagementRequest
{
    Param
    (
        [ValidateScript({$_.Token -ne $null})]
        [Parameter(Mandatory=$true)]$ClientInformation,
        $Requests
    )
    #Ensure is array
    $Request = @()+$Requests
    $Request = ConvertTo-Json -InputObject $Request -Depth 10 -Compress

    $URI = "https://usermanagement.adobe.io/v2/usermanagement/action/$($ClientInformation.OrgID)"
    $Headers = @{Accept="application/json";
            "Content-Type"="application/json";
            "x-api-key"=$ClientInformation.APIKey;
            Authorization="Bearer $($ClientInformation.Token.access_token)"}

    return (Invoke-RestMethod -Method Post -Uri $URI -Body $Request -Header $Headers)
}
