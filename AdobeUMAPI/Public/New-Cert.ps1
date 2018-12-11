<#NOTE: This file and function renamed from Create-Cert
    - Create not among the Powershell approved verbs.
#>

<#
.SYNOPSIS
    Creates a new self-signed certificate for use with Adobe.

.PARAMETER DNSName
    Name to append to cert. Defaults to "ADOBEAUTH.<yourdomain>"

.PARAMETER ExpiryYears
    How long before the certificate expires in years. Defaults to 6

.OUTPUTS
    New certificate in the current user's certificate store

.NOTES
    This is required to sign a JWT that will authenticate the service account. 
    After a cert is created, export it without the private key and upload it to your service account's information page at https://console.adobe.io/
    Export the private key as a pfx file and store it somewhere. Ensure you know the password as it is required.
  
.EXAMPLE
    Create-Cert
#>
function New-Cert
{
    Param
    (
        [string]$DNSName="ADOBEAUTH."+$env:USERDNSDOMAIN, 
        [int]$ExpiryYears=6
    )
    $Cert=New-SelfSignedCertificate -CertStoreLocation cert:\currentuser\my -DnsName $DNSName -KeyFriendlyName $DNSName -NotAfter ([DateTime]::Now).AddYears($ExpiryYears) -HashAlgorithm "SHA512" -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider"
}
