<#
.SYNOPSIS
    Converts a Base64Url string, to a decoded ASCII string

.PARAMETER Item
    A base64url string
  
.EXAMPLE
    ConvertFrom-Base64URL -Item "VGhpcyBpcyBhIHRlc3Q"
#>
function ConvertFrom-Base64URL
{
     Param([Parameter(Mandatory=$true)][string]$String)
     return [System.Text.ASCIIEncoding]::ASCII.GetString([convert]::FromBase64String((ConvertFrom-Base64URLToBase64 -String $String)))
}
