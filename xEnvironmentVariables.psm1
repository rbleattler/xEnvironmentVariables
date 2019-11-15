# Import Functions #

$Files = @(
    '{0}\Private' -f $PSScriptRoot,
    '{0}\Public' -f $PSScriptRoot
)

$ResourceFiles = Get-ChildItem $Files

foreach ($ScriptFile in $ResourceFiles) {
    Write-Verbose -Message "Importing $ScriptFile"
    . $ScriptFile.FullName
}
