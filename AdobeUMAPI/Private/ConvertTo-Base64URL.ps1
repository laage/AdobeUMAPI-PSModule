<#
.SYNOPSIS
    Converts a byte[], to a Base64URL encoded string

.PARAMETER Item
    A byte[]
  
.EXAMPLE
    ConvertTo-Base64URL -Item "VGhpcyBpcyBhIHRlc3Q="
#>
function ConvertTo-Base64URL
{
    Param([Parameter(Mandatory=$true)]$Item)
    return [Convert]::ToBase64String($Item).Split("=")[0].Replace('+', '-').Replace('/', '_')
}
