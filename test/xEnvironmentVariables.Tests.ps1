$ModuleManifestName = 'xEnvironmentVariables.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

Import-Module $ModuleManifestPath

Describe 'Tests for xEnvironmentVariables' {
    Context "Tests for getter for current process" {
        It "gets an environment variable for current process" {
            $var = Get-EnvironmentVariable -Name USERPROFILE -Scope Process -ShowProperties

            $var.Name | Should Be "USERPROFILE"
            $var.Value | Should Be $Env:USERPROFILE
            $var.ValueType | Should Be "String"
            $var.Scope | Should Be "Process"
            $var.BeforeExpansion | Should BeNullOrEmpty

            "$var" | Should Be $Env:USERPROFILE
        }
    }
    Context "Tests for setter for current process" {
        It "sets a basic environment variable for current process" {
            $params = @{
                Name      = "xEnvironmentVariables_TEST_SET_PROCESS"
                Value     = "basic_value"
                Scope     = "Process"
                ValueType = "String"
                Inherit   = "Auto"
            }
            $var = Set-EnvironmentVariable @params
            $var.Name | Should Be "xEnvironmentVariables_TEST_SET_PROCESS"
            $var.Value | Should Be "basic_value"
            $var.ValueType | Should Be "String"
            $var.Scope | Should Be "Process"
            $var.BeforeExpansion | Should BeNullOrEmpty

            $Env:xEnvironmentVariables_TEST_SET_PROCESS | Should Be "basic_value"
            "$var" | Should Be "basic_value"

            # clean up
            $Env:xEnvironmentVariables_TEST_SET_PROCESS = $null
        }
        It "sets an environment variable as ExpandString for current process" {
            $params = @{
                Name      = "xEnvironmentVariables_TEST_SET_PROCESS_EX"
                Value     = "USERNAME: %USERNAME%"
                Scope     = "Process"
                ValueType = "ExpandString"
                Inherit   = "Auto"
            }
            $var = Set-EnvironmentVariable @params
            $var.Name | Should Be "xEnvironmentVariables_TEST_SET_PROCESS_EX"
            $var.Value | Should Be "USERNAME: $Env:USERNAME"
            $var.ValueType | Should Be "String"
            $var.Scope | Should Be "Process"
            $var.BeforeExpansion | Should BeNullOrEmpty
            "$var" | Should Be "USERNAME: $Env:USERNAME"

            $Env:xEnvironmentVariables_TEST_SET_PROCESS_EX | Should Be "USERNAME: $Env:USERNAME"

            # clean up
            $Env:xEnvironmentVariables_TEST_SET_PROCESS_EX = $null
        }
    }
    Context "Tests for getter and setter for current user" {
        It "sets a basic environment variable for current user" {
            $params = @{
                Name      = "xEnvironmentVariables_TEST_SET_USER"
                Value     = "basic_value"
                Scope     = "User"
                ValueType = "String"
                Inherit   = "Auto"
            }
            $var = Set-EnvironmentVariable @params
            $var.Name | Should Be "xEnvironmentVariables_TEST_SET_USER"
            $var.Value | Should Be "basic_value"
            $var.ValueType | Should Be "String"
            $var.Scope | Should Be "User"
            $var.BeforeExpansion | Should be "basic_value"
            "$var" | Should Be "basic_value"

            # manual check
            [System.Environment]::GetEnvironmentVariable(
                "xEnvironmentVariables_TEST_SET_USER",
                "User"
            ) | Should Be "basic_value"

            # auto inheritance
            $Env:xEnvironmentVariables_TEST_SET_USER | Should Be "basic_value"

            # clean up
            [System.Environment]::SetEnvironmentVariable(
                "xEnvironmentVariables_TEST_SET_USER",
                "",
                "User"
            )
            $Env:xEnvironmentVariables_TEST_SET_USER = $null
        }

        It "sets an environment variable as ExpandString for current user" {
            $params = @{
                Name      = "xEnvironmentVariables_TEST_SET_USER_EX"
                Value     = "OS: %OS%"
                Scope     = "User"
                ValueType = "ExpandString"
                Inherit   = "Auto"
            }
            $var = Set-EnvironmentVariable @params
            $var.Name | Should Be "xEnvironmentVariables_TEST_SET_USER_EX"
            $var.Value | Should Be "OS: $Env:OS"
            $var.ValueType | Should Be "ExpandString"
            $var.Scope | Should Be "User"
            $var.BeforeExpansion | Should Be "OS: %OS%"
            "$var" | Should Be "OS: $Env:OS"

            # manual check
            [System.Environment]::GetEnvironmentVariable(
                "xEnvironmentVariables_TEST_SET_USER_EX",
                "User"
            ) | Should Be "OS: $Env:OS"

            # auto inheritance
            $Env:xEnvironmentVariables_TEST_SET_USER_EX | Should Be "OS: $Env:OS"

            # clean up
            [System.Environment]::SetEnvironmentVariable(
                "xEnvironmentVariables_TEST_SET_USER_EX",
                "",
                "User"
            )
            $Env:xEnvironmentVariables_TEST_SET_USER_EX = $null
        }
    }
    Context "Tests Get-EnvironmentVariables Output for current process" {
        $BasicGet = [System.Environment]::GetEnvironmentVariables("Process")
        foreach ($key in $BasicGet.Keys) {
            It "gets the correct value of the $key variable from current process" {
                $var = Get-EnvironmentVariables -Scope Process
                $BasicGetValue = $BasicGet.$key
                $var.$key | Should Be $BasicGetValue
            }
        }
    }
    Context "Tests Get-EnvironmentVariables Output for User" {
        $BasicGet = [System.Environment]::GetEnvironmentVariables("User")
        foreach ($key in $BasicGet.Keys) {
            It "gets the correct value of the $key variable from User" {
                $var = Get-EnvironmentVariables -Scope User
                $BasicGetValue = $BasicGet.$key
                $var.$key | Should Be $BasicGetValue
            }
        }
    }
    Context "Tests Get-EnvironmentVariables Output for Machine" {
        $BasicGet = [System.Environment]::GetEnvironmentVariables("Machine")
        foreach ($key in $BasicGet.Keys) {
            It "gets the correct value of the $key variable from Machine" {
                $var = Get-EnvironmentVariables -Scope Machine
                $BasicGetValue = $BasicGet.$key
                $var.$key | Should Be $BasicGetValue
            }
        }
    }
    Context "Tests Get-EnvironmentVariables Output is JSON" {
        It "Outputs the data as JSON" {
            $var = Get-EnvironmentVariables -OutputType JSON
            $var | ConvertFrom-Json | Should BeOfType [Object[]]
        }
    }
}
