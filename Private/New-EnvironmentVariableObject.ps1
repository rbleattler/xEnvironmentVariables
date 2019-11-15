#New-EnvironmentVariableObject.ps1
function New-EnvironmentVariableObject {
    param (
        [OutputType([HashTable])]
        [Parameter(Mandatory)]
        [ValidatePattern("[^=]+")]
        $Name,
        [Parameter()]
        [AllowNull()]
        [String]
        $Value,
        [Parameter(Mandatory)]
        [System.EnvironmentVariableTarget]
        $Scope,
        [Parameter()]
        [AllowNull()]
        [ValidateSet("String", "ExpandString", $null)]
        [String]
        $ValueType,
        [Parameter()]
        [AllowNull()]
        [String]
        $BeforeExpansion
    )

    begin {
    }

    process {
        $OutPut = [PSCustomObject]@{
            Name            = $Name
            Value           = $Value
            Scope           = $Scope
            ValueType       = $ValueType
            BeforeExpansion = $BeforeExpansion
        }
        $OutPut
    }

    end {
    }
}