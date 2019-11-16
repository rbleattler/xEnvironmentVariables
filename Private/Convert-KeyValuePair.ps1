function Convert-KeyValuePair {
    param (
        [Parameter(Mandatory)]
        [System.Collections.Hashtable]
        $InputObject,
        [Parameter(Mandatory)]
        [String]
        [ValidateSet('String', 'Array', 'CSV', 'Object', 'JSON')]
        $OutputType,
        [Parameter(Mandatory)]
        [String]
        [ValidateSet('Name', 'Value', 'Both')]
        $OutputElements
    )
    if ($OutputType -eq 'Object' -and $OutputElements -ne 'Both') {
        Write-Warning 'Writing Output as an Object will always output both Keys (Names) and values'
    }

    try {
        switch ($OutputType) {
            Array {
                if ($OutputElements -ne 'Both') {
                    $OutputObject = $InputObject.GetEnumerator() | Select-Object $OutputElements
                } else {
                    $OutputObject = Format-Hashtable -HashtableIn $InputObject -KeyHeading Name -ValueHeading Value
                }
            }
            String {
                if ($OutputElements -ne 'Both') {
                    $OutputObject = ($EnvironmentVariables.GetEnumerator() | Select-Object -ExpandProperty $OutputElements) | Join-String -Separator ' '
                } else {
                    $OutputObject = Format-Hashtable -HashtableIn $InputObject -KeyHeading Name -ValueHeading Value -OutString
                }
            }
            CSV {
                if ($OutputElements -ne 'Both') {
                    $OutputObject = ($EnvironmentVariables.GetEnumerator() | Select-Object -ExpandProperty $OutputElements) | Join-String -Separator ', '
                } else {
                    $OutputObject = Format-Hashtable -HashtableIn $InputObject -KeyHeading Name -ValueHeading Value -OutCsv
                }
            }
            JSON {
                if ($OutputElements -ne 'Both') {
                    $OutputObject = ($EnvironmentVariables.GetEnumerator() | Select-Object -ExpandProperty $OutputElements) | ConvertTo-Json
                } else {
                    $OutputObject = Format-Hashtable -HashtableIn $InputObject -KeyHeading Name -ValueHeading Value -OutJson
                }
            }
            Object {
                $NewObjectProperties = New-Object -TypeName System.Collections.Hashtable @{ }
                foreach ($KeyValuePair in $EnvironmentVariables.GetEnumerator()) {
                    $NewObjectProperties += @{
                        $KeyValuePair.Key = $KeyValuePair.Value
                    }
                }
                $OutputObject = New-Object -TypeName PSCustomObject -Property $NewObjectProperties | Add-Member -Name ToString -MemberType ScriptMethod -Value { 'Name: {0}, Value: {1}' -f $this.Name,$this.Value } -Force -Passthru
            }
        }

        $OutputObject
    } catch {
        $ScriptName = $_.InvocationInfo.ScriptName
        $Position = 'In {2} At Line: {0} Char: {1}' -f $_.InvocationInfo.ScriptLineNumber, $_.InvocationInfo.OffsetInLine, $ScriptName
        $Category = $_.CategoryInfo.Category
        Write-Error -Message "Error was `"$_`"" -Category $Category -CategoryTargetName $Position
    }

}