# xEnvironmentVariables

[![Build Status](https://dev.azure.com/mytgnq/pwsh-xEnvironmentVariables/_apis/build/status/GNQG.pwsh-xEnvironmentVariables?branchName=master)](https://dev.azure.com/mytgnq/pwsh-xEnvironmentVariables/_build/latest?definitionId=1&branchName=master)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/xEnvironmentVariables)](https://www.powershellgallery.com/packages/xEnvironmentVariables/)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/p/xEnvironmentVariables)](https://www.powershellgallery.com/packages/xEnvironmentVariables/)

A PowerShell module to handle environment variables,  supporting variable expansion.

## Install

```powershell
Install-Module xEnvironmentVariables
```

## Usage

```powershell
PS> Import-Module xEnvironmentVariables
PS> $var = Get-EnvironmentVariable -Name SOME_ENVIRONMENTVARIABLE -Scope Process
PS> $var
# returns a custom object
#
# Name            : SOME_ENVIRONMENTVARIABLE
# Value           : some_value
# Scope           : Process
# ValueType       : String
# BeforeExpansion :

PS> "$var" -eq "some_value"
# True (`ToString` method is overridden)

PS> Set-EnvironmentVariable -Name NEW_ENVIRONMENTVARIABLE-Value new_value -Scope User -ValueType String -Inherit Auto
# sets an environment variable
# returns the result of `Get-EnvironmentVariable NEW_ENVIRONMENTVARIABLE`
#
# Name            : NEW_ENVIRONMENTVARIABLE
# Value           : new_value
# Scope           : User
# ValueType       : String
# BeforeExpansion :

PS> Set-EnvironmentVariable -Name EXPANDED -Value 'expanded: %NEW_ENVIRONMENTVARIABLE%' -Scope User -ValueType ExpandString -Inherit Auto
# set an environment variable as ExpandString
#
# Name            : EXPANDED
# Value           : expanded: new_value
# Scope           : User
# ValueType       : ExpandString
# BeforeExpansion : expanded: %NEW_ENVIRONMENTVARIABLE%
```

## License

[MIT License (c) 2019 @GNQG](LICENSE)
