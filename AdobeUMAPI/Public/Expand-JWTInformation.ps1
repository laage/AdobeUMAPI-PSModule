<#
.SYNOPSIS
    Unpacks a JWT object into it's header, and body components. (Human readable format)

.PARAMETER JWTObject
    JWT To unpack. In format of {Base64Header}.{Base64Body}.{Base64Signature}

.PARAMETER SigningCert
    A certificate with the necesary public key to verify signature block. Can be null, will not validate signature.

.NOTES
    See https://www.adobe.io/apis/cloudplatform/usermanagement/docs/samples/samplemultiaction.html
    This should be posted to https://usermanagement.adobe.io/v2/usermanagement/action/{myOrgID}
  
.EXAMPLE
    Expand-JWTInformation -JWTObject "xxxx.xxxx.xxx"
#>
function Expand-JWTInformation
{
    Param
    (
        [ValidateScript({$_.Split(".").Length -eq 3})]
        [Parameter(Mandatory=$true)][string]$JWTObject, 
        $SigningCert
    )
    $JWTParts = $JWTObject.Split(".")
    $Header =(ConvertFrom-Json -InputObject (ConvertFrom-Base64URL -String $JWTParts[0]));
    $RawData = [System.Text.ASCIIEncoding]::ASCII.GetBytes($JWTParts[0]+"."+$JWTParts[1])

    $Signature = [System.Convert]::FromBase64String((ConvertFrom-Base64URLToBase64 -String $JWTParts[2]))

    $Valid= $null
    if ($SigningCert -and $Header.alg.StartsWith("RS"))
    {
        $HAN=$null
        if ($Header.alg.EndsWith("256"))
        {
            $HAN = [System.Security.Cryptography.HashAlgorithmName]::SHA256
        }
        elseif ($Header.alg.EndsWith("512"))
        {
            $Han = [System.Security.Cryptography.HashAlgorithmName]::SHA512
        }
        elseif ($Header.alg.EndsWith("384"))
        {
            $Han = [System.Security.Cryptography.HashAlgorithmName]::SHA384
        }
        if ($HAN)
        {
            $Valid = $SigningCert.PublicKey.Key.VerifyData($RawData, $Signature, $Han, [System.Security.Cryptography.RSASignaturePadding]::Pkcs1)
        }
    }
    return (New-Object -TypeName PSObject -ArgumentList @{Header=$Header;
                                                          Body=(ConvertFrom-Json -InputObject (ConvertFrom-Base64URL -String $JWTParts[1]));
                                                          SignatureValid=$Valid})
}
