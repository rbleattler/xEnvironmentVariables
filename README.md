# xEnvironmentVariables

[![Build Status](https://rableattler.visualstudio.com/xEnvironmentVariables/_apis/build/status/rbleattler.xEnvironmentVariables?branchName=master)](https://rableattler.visualstudio.com/xEnvironmentVariables/_build/latest?definitionId=3&branchName=master)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/xEnvironmentVariables)](https://www.powershellgallery.com/packages/xEnvironmentVariables/)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/p/xEnvironmentVariables)](https://www.powershellgallery.com/packages/xEnvironmentVariables/)

A PowerShell module to handle environment variables,  supporting variable expansion.

## Install

```powershell
Install-Module xEnvironmentVariables
```

## Usage

### Import Module
```powershell
PS> Import-Module xEnvironmentVariables
```
### Set-EnvironmentVariable Examples

#### Set a string Environment Variable in the Machine Scope
```powershell
PS C:\> Set-EnvironmentVariable -name TestVar -Value 'TestValue' -Scope Machine -ValueType String -Inherit Auto

Name            : TestVar
Value           : TestValue
Scope           : Machine
ValueType       : String
BeforeExpansion :
```

#### Set an ExpandString Environment Variable in the Machine Scope
The BeforeExpansion Value is the true value of the environment variable.

```powershell
PS C:\> Set-EnvironmentVariable -name TestPathVar -Value '%TEMP%\TestValue' -Scope Machine -ValueType ExpandString -Inherit Auto

Name            : TestPathVar
Value           : C:\Users\USERNAME\AppData\Local\Temp\TestValue
Scope           : Machine
ValueType       : ExpandString
BeforeExpansion : %TEMP%\TestValue
```

#### Set an ExpandString Environment Variable in the Machine Scope
The BeforeExpansion Property value is the same as the Value Property because there are no EnvironmentVariables to expand.

```powershell
PS C:\> Set-EnvironmentVariable -name TestPathVar -Value '%TEMP%\TestValue' -Scope Machine -ValueType String -Inherit Auto

Name            : TestPathVar
Value           : C:\Users\USERNAME\AppData\Local\Temp\TestValue
Scope           : Machine
ValueType       : String
BeforeExpansion : C:\Users\USERNAME\AppData\Local\Temp\TestValue
```
### Get-EnvironmentVariable Examples

#### Get a string Environment Variable in the Machine Scope with the ShowProperties switch
The ShowProperties switch results in the full Property Set being returned.

```powershell
PS C:\> Get-EnvironmentVariable -name TestVar -Scope Machine -ShowProperties

Name            : TestVar
Value           : TestValue
Scope           : Machine
ValueType       : String
BeforeExpansion : TestValue
```

#### Get an ExpandString Environment Variable in the Machine Scope with the ShowProperties switch
The ShowProperties switch results in the full Property Set being returned. The BeforeExpansion Property shows the unexpanded value of the Environment Variable.

```powershell
PS C:\> Get-EnvironmentVariable -name TestPathVar -Scope Machine -ShowProperties

Name            : TestPathVar
Value           : C:\Users\rblea\AppData\Local\Temp\TestValue2
Scope           : Machine
ValueType       : String
BeforeExpansion : %TEMP%\TestValue2
```

#### Get an ExpandString Environment Variable in the Machine Scope
The expanded value of the TestPathVar Environment Variable is returned.

```powershell
PS C:\>  Get-EnvironmentVariable -name TestPathVar -Scope Machine
C:\Users\USER\AppData\Local\Temp\TestValue2
```

#### Get an ExpandString Environment Variable in the Machine Scope with the Expanded switch
The unexpanded value of the TestPathVar Environment Variable is returned.

```powershell
PS C:\> Get-EnvironmentVariable -name TestPathVar -Scope Machine -Expanded
%TEMP%\TestValue2
```

#### Get Environment Variables in the Machine Scope

```powershell
PS C:\> Get-EnvironmentVariables -Scope Machine
PROCESSOR_LEVEL                 : 23
TestPathVar2                    : C:\Users\USER\AppData\Local\Temp\TestValue2
USERNAME                        : SYSTEM
PROCESSOR_ARCHITECTURE          : AMD64
TestVar                         : TestValue
NUMBER_OF_PROCESSORS            : 12
PROCESSOR_REVISION              : 0802
...
```

#### Get Environment Variables in the Process Process

```powershell
PS C:\> Get-EnvironmentVariables
USERDOMAIN                      : ComputerDomain
COLORTERM                       : truecolor
ComSpec                         : C:\WINDOWS\system32\cmd.exe
TERM_PROGRAM_VERSION            : 1.40.0
TestPathVar2                    : C:\WINDOWS\TEMP\TestValue2
CommonProgramFiles              : C:\Program Files\Common Files
NUMBER_OF_PROCESSORS            : 12
...
```

#### Get Environment Variables and output as JSON

```powershell
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
```

#### Get Environment Variables and output as CSV

```powershell
PS C:\> Get-EnvironmentVariables -OutputType CSV
PROCESSOR_IDENTIFIER,PROCESSOR_ARCHITECTURE,ProgramData,OS,TestValue2...
"AMD64 Family 23 Model 8 Stepping 2, AuthenticAMD",AMD64,C:\ProgramData,Windows_NT,%TMP%\TestValue3...
```

#### Get Environment Variables and output as Array

```powershell
PS C:\> Get-EnvironmentVariables -OutputType Array
Name                            Value
----                            -----
PROCESSOR_IDENTIFIER            AMD64 Family 23 Model 8 Stepping 2, AuthenticAMD
PROCESSOR_ARCHITECTURE          AMD64
ProgramData                     C:\ProgramData
OS                              Windows_NT
TestValue2                      %TMP%\TestValue3
...
```

#### Get Environment Variable Names only and output as Array

```powershell
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
```

#### Get-EnvironmentVariables Special Note ####
When returning only names or values, you must specify another output type as the default output type is a Custom Object containing both Names and Values.

## License

[MIT License (c) 2019 @rbleattler](LICENSE.txt)
