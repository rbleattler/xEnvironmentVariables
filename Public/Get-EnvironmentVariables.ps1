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
        [ValidateSet("String", "Array", "CSV", "Object","JSON")]
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