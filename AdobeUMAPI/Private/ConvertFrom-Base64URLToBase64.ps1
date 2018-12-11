<#
.SYNOPSIS
    Converts a Base64Url string, to a .Net base64 string

.PARAMETER Item
    A base64url string
  
.EXAMPLE
    ConvertFrom-Base64URLToBase64 -Item "VGhpcyBpcyBhIHRlc3Q"
#>
function ConvertFrom-Base64URLToBase64
{
     Param([Parameter(Mandatory=$true)][string]$String)
     $String = $String.Replace('-', '+').Replace('_', '/')
     while ((($String.Length)*6)%8-ne 0)
     {
         $String = $String+"="
     }
     return $String
}
