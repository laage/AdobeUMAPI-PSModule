<#
.SYNOPSIS
    Converts the [datetime] object passed into a java compliant numerical representation. (milliseconds since 1/1/1970)

.PARAMETER DateTimeObject
    A DateTime to be converted
  
.EXAMPLE
    ConvertTo-JavaTime -DateTimeObject ([DateTime]::Now)
#>
function ConvertTo-JavaTime
{
    Param([Parameter(Mandatory=$true)][DateTime]$DateTimeObject)
    #Take DateTime, convert to file time (100 nano second ticks since 1/1/1607). Subtract 1/1/1970 from that using the same 100nanoticks. Then multiply to convert from nanoticks to milliseconds since 1/1/1970. 
    return [int64](($DateTimeObject.ToFileTimeUtc()-[DateTime]::Parse("01/01/1970").ToFileTimeUtc())*0.0001)
}
