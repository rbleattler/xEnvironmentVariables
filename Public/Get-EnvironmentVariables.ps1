<#
.SYNOPSIS
A PowerShell module to handle environment variables, supporting variable expansion. This function handles GETTING ALL environment variables.

.DESCRIPTION
This module is capable of Retrieving Environment Variables in any scope (Process, User, Machine).

.PARAMETER Names
[switch] Returns only the Names of the environment variables.

.PARAMETER Scope
[System.EnvironmentVariableTarget], [String]
Specify the scope to search for the target Environment Variable.

Process : Environment Variables in the running process.

User    : Environment Variables in the User Scope affect the Global Environment Variables for the current user.

Machine : Environment Variables in the Machine Scope change the settings in the registry for all users.

.PARAMETER OutputType
[String]
Specify the output type for the command.

"String"    : Returns the value as a simple string of values separated by spaces.
"Array"     : Returns an array of string values
"CSV"       : Returns a Two line CSV (Comma Delimited)
"Object"    : Returns a PSCustomObject with Variable names as Object Properties whose values are those of the Environment Variables
"JSON"      : Returns a JSON output where each node contains a 'Name' and 'Value' for one Environment Variable.

.EXAMPLE
Get Environment Variables in the Process Scope

PS C:\> Get-EnvironmentVariables
USERDOMAIN                      : ComputerDomain
COLORTERM                       : truecolor
ComSpec                         : C:\WINDOWS\system32\cmd.exe
TERM_PROGRAM_VERSION            : 1.40.0
TestPathVar2                    : C:\WINDOWS\TEMP\TestValue2
CommonProgramFiles              : C:\Program Files\Common Files
NUMBER_OF_PROCESSORS            : 12
...
.EXAMPLE
Get Environment Variables in the Machine Scope

PS C:\> Get-EnvironmentVariables -Scope Machine
PROCESSOR_LEVEL                 : 23
TestPathVar2                    : C:\Users\USER\AppData\Local\Temp\TestValue2
USERNAME                        : SYSTEM
PROCESSOR_ARCHITECTURE          : AMD64
TestVar                         : TestValue
NUMBER_OF_PROCESSORS            : 12
PROCESSOR_REVISION              : 0802
...

.EXAMPLE
PS C:\> Get-EnvironmentVariables -OutputType JSON
[
  {
    "Name": "PROCESSOR_IDENTIFIER",
    "Value": "AMD64 Family 23 Model 8 Stepping 2, AuthenticAMD"
  },
  {
    "Name": "PROCESSOR_ARCHITECTURE",
    "Value": "AMD64"
  },
  {
    "Name": "ProgramData",
    "Value": "C:\\ProgramData"
  },
  {
    "Name": "OS",
    "Value": "Windows_NT"
  },
  {
    "Name": "TestValue2",
    "Value": "%TMP%\\TestValue3"
  },
  {
    "Name": "USERPROFILE",
    "Value": "C:\\Users\\USERNAME"
  },
  {
    "Name": "ALLUSERSPROFILE",
    "Value": "C:\\ProgramData"
  },
  {
    "Name": "CommonProgramW6432",
    "Value": "C:\\Program Files\\Common Files"
  },
  {
    "Name": "TestPathVar2",
    "Value": "C:\\WINDOWS\\TEMP\\TestValue2"
  },
  {
    "Name": "PROCESSOR_LEVEL",
    "Value": "23"
  },
  {
    "Name": "ProgramFiles(x86)",
    "Value": "C:\\Program Files (x86)"
  },
  {
    "Name": "ProgramW6432",
    "Value": "C:\\Program Files"
  },
  {
    "Name": "HOMEDRIVE",
    "Value": "C:"
  },
...
]
.EXAMPLE
PS C:\> Get-EnvironmentVariables -OutputType CSV
PROCESSOR_IDENTIFIER,PROCESSOR_ARCHITECTURE,ProgramData,OS,TestValue2...
"AMD64 Family 23 Model 8 Stepping 2, AuthenticAMD",AMD64,C:\ProgramData,Windows_NT,%TMP%\TestValue3...

.EXAMPLE
PS C:\> Get-EnvironmentVariables -OutputType Array
Name                            Value
----                            -----
PROCESSOR_IDENTIFIER            AMD64 Family 23 Model 8 Stepping 2, AuthenticAMD
PROCESSOR_ARCHITECTURE          AMD64
ProgramData                     C:\ProgramData
OS                              Windows_NT
TestValue2                      %TMP%\TestValue3
...

.EXAMPLE
PS C:\> Get-EnvironmentVariables -OutputType Array -Names

Name
----
PROCESSOR_IDENTIFIER
PROCESSOR_ARCHITECTURE
ProgramData
OS
TestValue2
DriverData
ComSpec
USERPROFILE
ALLUSERSPROFILE
LOGONSERVER
USERDOMAIN_ROAMINGPROFILE
TERM_PROGRAM_VERSION
PSExecutionPolicyPreference
...

.INPUTS
[String]

.OUTPUTS
[Hashtable],[String],[JSON],[CSV],[PSCustomObject]

.NOTES

.LINK
https://github.com/rbleattler/xEnvironmentVariables

#>
function Get-EnvironmentVariables {
    param (
        [Parameter()]
        [System.EnvironmentVariableTarget]
        [System.String]
        $Scope = [System.EnvironmentVariableTarget]::Process,
        [Parameter()]
        [Switch]
        $Names,
        [Parameter()]
        [Switch]
        $Values,
        [Parameter()]
        [ValidateSet("String", "Array", "CSV", "Object", "JSON")]
        [String]
        $OutputType = "Object"
    )
    if ($Scope.GetTypeCode() -eq 'String') {
        $Scope = [System.EnvironmentVariableTarget]::$Scope
    }
    try {
        $EnvironmentVariables = [System.Environment]::GetEnvironmentVariables($Scope)

        if ((!$Names -and !$Values) -or ($Names -and $Values)) {
            $ConversionOutputType = 'Both'
        } elseif (!$Values -and $Names) {
            $ConversionOutputType = 'Name'
        } elseif (!$Names -and $Values) {
            $ConversionOutputType = 'Value'
        } else {
            throw "Invalid Selection"
        }

        Convert-KeyValuePair -InputObject $EnvironmentVariables -OutputType $OutputType -OutputElements $ConversionOutputType

    } catch {
        $ScriptName = $_.InvocationInfo.ScriptName
        $Position = 'In {2} At Line: {0} Char: {1}' -f $_.InvocationInfo.ScriptLineNumber, $_.InvocationInfo.OffsetInLine, $ScriptName
        $Category = $_.CategoryInfo.Category
        Write-Error -Message "Error was `"$_`"" -Category $Category -CategoryTargetName $Position
    }




}