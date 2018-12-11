<#
.SYNOPSIS
    Adds an adobe auth token to the ClientInformation object passed to it

.PARAMETER ClientInformation 
    Your ClientInformation object

.PARAMETER SignatureCert 
    The cert that is attached to the specified account. Must have private key. Check which cert at https://console.adobe.io/

.PARAMETER AuthTokenURI 
    URI of the Adobe Auth Service. Defaults to https://ims-na1.adobelogin.com/ims/exchange/jwt/

.PARAMETER ExpirationInHours 
    When the request token should expire in hours. Defaults to 1

.OUTPUTS
    Attached auth token to ClientInformation.Token

.NOTES
    Create JWT https://www.adobe.io/apis/cloudplatform/console/authentication/createjwt/jwt_nodeJS.html
    https://github.com/lambtron/nextbus/blob/master/node_modules/jwt-simple/lib/jwt.js
    https://jwt.io/
  
.EXAMPLE
    Get-AdobeAuthToken -ClientInformation $MyClient -SignatureCert $Cert -ExpirationInHours 12
#>
function Get-AdobeAuthToken
{
    Param
    (
        [Parameter(Mandatory=$true)]$ClientInformation,
        [ValidateScript({$_.PrivateKey -ne $null})] 
        [Parameter(Mandatory=$true)]$SignatureCert, 
        [string]$AuthTokenURI="https://ims-na1.adobelogin.com/ims/exchange/jwt/", 
        [int]$ExpirationInHours=1
    )
    $PayLoad = New-Object -TypeName PSObject -Property @{
                                                            iss=$ClientInformation.OrgID;
                                                            sub=$ClientInformation.TechnicalAccountID;
                                                            aud="https://ims-na1.adobelogin.com/c/"+$ClientInformation.APIKey;
                                                            "https://ims-na1.adobelogin.com/s/ent_user_sdk"=$true;#MetaScope
                                                            exp=(ConvertTo-JavaTime -DateTimeObject ([DateTime]::Now.AddHours($ExpirationInHours)));
                                                        }
    #Header for the JWT
    $Header = ConvertTo-Json -InputObject (New-Object PSObject -Property @{typ="JWT";"alg"="RS256"}) -Compress
    
    #Body of the JWT. This is our actual request
    $JWT = ConvertTo-Base64URL -Item ([System.Text.ASCIIEncoding]::ASCII.GetBytes((ConvertTo-Json -InputObject $PayLoad -Compress)))
    
    #Join them together. as base64 strings, with a "." between them
    $JWT = (ConvertTo-Base64URL -Item ([System.Text.ASCIIEncoding]::ASCII.GetBytes($Header)))+"."+$JWT
    #Sign the data
    $JWTSig = ConvertTo-Base64URL -Item ($SignatureCert.PrivateKey.SignData([System.Text.ASCIIEncoding]::UTF8.GetBytes($JWT), [System.Security.Cryptography.HashAlgorithmName]::SHA256, [System.Security.Cryptography.RSASignaturePadding]::Pkcs1))
    #Append the signature. This is now a complete JWT
    $JWT = $JWT+"."+$JWTSig

    #Now we request the auth token
    $Body = "client_id=$($ClientInformation.APIKey)&client_secret=$($ClientInformation.ClientSecret)&jwt_token=$JWT"
    $ClientInformation.Token=Invoke-RestMethod -Method Post -Uri $AuthTokenURI -Body $Body -ContentType "application/x-www-form-urlencoded"
}
