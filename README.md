# xEnvironmentVariables

[![Build Status](https://rableattler.visualstudio.com/xEnvironmentVariables/_apis/build/status/xEnvironmentVariables?branchName=master)](https://rableattler.visualstudio.com/xEnvironmentVariables/_build/latest?definitionId=1&branchName=master)
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



## License

[MIT License (c) 2019 @rbleattler](LICENSE.txt)
