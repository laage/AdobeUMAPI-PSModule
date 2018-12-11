<#
.SYNOPSIS
    Load a certificate with a private key from file

.PARAMETER Password
    Password to open PFX

.PARAMETER CertPath
    Path to PFX File

.NOTES
    If you hard-code the password in a script utilizing this function, you should ensure the script is itself, somewhere secure

.EXAMPLE
    Load-PFXCert -Password "ASDF" -CertPath "C:\Cert.pfx"
#>
function Load-PFXCert
{
    Param
    (
        [string]$Password,
        [ValidateScript({Test-Path -Path $_})]
        [Parameter(Mandatory=$true)][string]$CertPath
    )
    $Collection = [System.Security.Cryptography.X509Certificates.X509Certificate2Collection]::new() #Because I could not get the private key utilizing "cert:\etc\etc"
    $Collection.Import($CertPath, $Password, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::PersistKeySet)
    return $Collection[0]
}
