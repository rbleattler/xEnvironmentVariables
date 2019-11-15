<#
.SYNOPSIS
A PowerShell module to handle environment variables, supporting variable expansion. This function handles SETTING environment variables.

.DESCRIPTION
This module is capable of setting Environment Variables in any scope (Process, User, Machine). It will return the value of the Envrionment Variable on completion.

.PARAMETER Name
[String] Specify the name of the Environment Variable to be set.

.PARAMETER Value
[String] Specify the value to set in the target Environment Variable.

.PARAMETER Scope
[System.EnvironmentVariableTarget], [String]
Specify the scope in which to affect the target Environment Variable.

Process : Environment Variables in the CURRENT process will be affected. Other processes will not be 'aware' of this change.

User    : Environment Variables in the User Scope affect the Global Environment Variables for the current user. Other users who log on to the machine will not be affected by these changes.

Machine : Environment Variables in the Machine Scope change the settings in the registry for all users. These changes will be visible to all processes.

.PARAMETER ValueType
String        : A simple string value
ExpandString  : A string value which contains unexpanded environment variables in the syntax of %VARIABLENAME%. These variables will NOT be expanded when the value is set in the registry.

.PARAMETER Inherit
Always, Never, Auto
If Set Always, the current process will inherit the changes applied to the User or Machine Variables. This is set to Auto by default. When set to Auto, the command will determine whether or not to update the setting. If the current (pre-operation) value of the variable in Process is equal to that in the target scope, the changes will be inherited.

.EXAMPLE
PS C:\> Set-EnvironmentVariable -name TestVar -Value 'TestValue' -Scope Machine -ValueType String -Inherit Auto

Name            : TestVar
Value           : TestValue
Scope           : Machine
ValueType       : String
BeforeExpansion :

.EXAMPLE
PS C:\> Set-EnvironmentVariable -name TestPathVar -Value '%TEMP%\TestValue' -Scope Machine -ValueType ExpandString -Inherit Auto

Name            : TestPathVar
Value           : C:\Users\USERNAME\AppData\Local\Temp\TestValue
Scope           : Machine
ValueType       : ExpandString
BeforeExpansion : %TEMP%\TestValue


.EXAMPLE
PS C:\> Set-EnvironmentVariable -name TestPathVar -Value '%TEMP%\TestValue' -Scope Machine -ValueType String -Inherit Auto

Name            : TestPathVar
Value           : C:\Users\USERNAME\AppData\Local\Temp\TestValue
Scope           : Machine
ValueType       : String
BeforeExpansion : C:\Users\USERNAME\AppData\Local\Temp\TestValue

Because we set the ValueType to ExpandString, the value was set without expanding the string

PS C:\> Get-EnvironmentVariable -Name TestPathVar -Scope Machine
%TEMP%\TestValue
PS C:\> Get-EnvironmentVariable -Name TestPathVar -Scope Process

Because there is no Variable called TestPathVar in the Process Scope, it did not inherit the value.


.INPUTS
[String]

.OUTPUTS
[Hashtable],[String]

.NOTES

.LINK
https://github.com/rbleattler/xEnvironmentVariables

#>
function Set-EnvironmentVariable {
    [CmdletBinding()]
    param (
        # Name of the environment variable
        [Parameter(Position = 0, Mandatory)]
        [ValidatePattern("[^=]+")]
        [String]
        $Name,
        # Value of the environment variable
        [Parameter(Position = 1, Mandatory)]
        [String]
        $Value,
        # Scope of the environment variable
        [Parameter()]
        [System.EnvironmentVariableTarget]
        [System.String]
        $Scope = [System.EnvironmentVariableTarget]::Process,
        # Type of the environment variable
        [Parameter()]
        [ValidateSet("String", "ExpandString")]
        [String]
        $ValueType = "String",
        # Inheritance method for the environment variable
        [Parameter()]
        [ValidateSet("Always", "Auto", "Never")]
        [String]
        $Inherit = "Auto"
    )

    try {
        # Inheritance condition
        if ($Scope.GetTypeCode() -eq 'String') {
            $Scope = [System.EnvironmentVariableTarget]::$Scope
        }
        if ($Scope -eq "Process") {
            $Inheritance = $false
        } else {
            $Inheritance = switch ($Inherit) {
                "Never" {
                    $false
                }
                "Always" {
                    $true
                }
                "Auto" {
                    $CurrentProcessValue = [System.Environment]::GetEnvironmentVariable($Name, "Process")
                    if ($Name -eq "Path") {
                        $CurrentMachineValue = [System.Environment]::GetEnvironmentVariable($Name, "Machine")
                        $CurrentUserValue = [System.Environment]::GetEnvironmentVariable($Name, "User")
                        $CurrentValue = $CurrentMachineValue + $CurrentUserValue
                    } else {
                        $CurrentValue = [System.Environment]::GetEnvironmentVariable($Name, $Scope)
                    }

                    if ($CurrentValue -eq $CurrentProcessValue) {
                        $true
                    } else {
                        $false
                    }
                }
                Default { }
            }
        }
        if ($ValueType -ne "ExpandString" -or $Scope -eq 'Process') {
            $EnvironmentVariableValue = [System.Environment]::ExpandEnvironmentVariables($Value)
            [System.Environment]::SetEnvironmentVariable($Name, $EnvironmentVariableValue , $Scope)
        } else {
            $EnvironmentPath = Get-EnvironmentPath -Scope $Scope
            Set-ItemProperty -Path $EnvironmentPath -Name $Name -Value $Value -Type $ValueType
        }

        Update-EnvironmentVariableSettings

        # inherit
        if ($Inheritance) {
            if ($Name -eq "Path") {
                $CurrentMachineValue = [System.Environment]::GetEnvironmentVariable($Name, "Machine")
                $CurrentUserValue = [System.Environment]::GetEnvironmentVariable($Name, "User")
                $CurrentValue = $CurrentMachineValue + $CurrentUserValue
            } else {
                $CurrentValue = [System.Environment]::GetEnvironmentVariable($Name, $Scope)
            }
            [System.Environment]::SetEnvironmentVariable($Name, $CurrentValue, "Process")
        }
        if ($ValueType -eq 'ExpandString') {
            Get-EnvironmentVariable -Name $Name -Scope $Scope -ShowProperties
        } else {
            Get-EnvironmentVariable -Name $Name -Scope $Scope -Expanded -ShowProperties
        }

    } catch {
        $ScriptName = $_.InvocationInfo.ScriptName
        $Position = 'In {2} At Line: {0} Char: {1}' -f $_.InvocationInfo.ScriptLineNumber, $_.InvocationInfo.OffsetInLine, $ScriptName
        $Category = $_.CategoryInfo.Category
        Write-Error -Message "Error was `"$_`"" -Category $Category -CategoryTargetName $Position
    }
}
