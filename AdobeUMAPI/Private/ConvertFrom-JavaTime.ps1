<#
.SYNOPSIS
    Converts the java compliant numerical representation of time to a .net [datetime] object.

.PARAMETER JavaTime
    A JavaTime to be converted
  
.EXAMPLE
    ConvertFrom-JavaTime -JavaTime 1500000000000
#>
function ConvertFrom-JavaTime
{
    Param([Parameter(Mandatory=$true)][int64]$JavaTime)
    #Take the javatime, multiply it by 10000 to convert from millisecond ticks to 100 nanosecond ticks. Then add the 100 nano second tickets since 1970 to that number. This gives us the current file time.
    #Then convert file time to [datetime] object
    return [DateTime]::FromFileTimeUtc($JavaTime*10000+[DateTime]::Parse("01/01/1970").ToFileTimeUtc())
}
