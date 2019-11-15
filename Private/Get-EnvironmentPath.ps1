function Get-EnvironmentPath {
    param (
        [Parameter(Mandatory)]
        [System.EnvironmentVariableTarget]
        $Scope
    )
    switch ($Scope) {
        "Process" {
            "Env:"
        }
        "User" {
            "Registry::HKEY_CURRENT_USER\Environment"
        }
        "Machine" {
            "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
        }
        Default {
            $null
        }
    }
}