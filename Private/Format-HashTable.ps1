<#
    .SYNOPSIS
    This function allows for the manipulation of hashtable headings.

    .DESCRIPTION
    This function allows for the manipulation of Hashtable headings. The output
    is an Array -- not a Hashtable. All object data will be lost on output.

    .PARAMETER HashtableIn
    This paramater is the input object. It must be of the type [Hashtable].

    .PARAMETER KeyHeading
    Type: [String]
    The new left side heading value.

    .PARAMETER ValueHeading
    Type: [String]
    The new right side heading value.

    .EXAMPLE
    Format-Hashtable -HashtableIn @{'one'=1;'two'=2} -KeyHeading LeftHeading -ValueHeading RightHeading

    The output of the Hashtable in HashTableIn before formatting is:

    PS C:\> @{'one'=1;'two'=2}

    Name                           Value
    ----                           -----
    one                            1
    two                            2

    The output of the command above is:

    PS C:\> Format-Hashtable -Hashtable @{'one'=1;'two'=2} -KeyHeading LeftHeading -ValueHeading RightHeading

    LeftHeading RightHeading
    ---------- -----------
    one                  1
    two                  2


    .NOTES
    This function is meant to make the output of a hashtable more readable by changing the Heading values to
    be more descriptive.


    .INPUTS
    Hashtable, String

    .OUTPUTS
    Array
#>
function Format-Hashtable
{
  param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [hashtable]
    $HashtableIn,
    [ValidateNotNullOrEmpty()]
    [string]
    $KeyHeading = 'Name',
    [ValidateNotNullOrEmpty()]
    [string]
    $ValueHeading = 'Value',
    [switch]
    $OutString,
    [switch]
    $OutCsv,
    [switch]
    $OutJson
  )

  $Output = $HashtableIn.GetEnumerator() | Select-Object -Property @{
    Label      = $KeyHeading
    Expression = {
      $_.Key
    }
  }, @{
    Label      = $ValueHeading
    Expression = {
      $_.Value
    }
  }

  if ($OutString) {
    $OutputStringBuilder = [System.Text.StringBuilder]::new()
    foreach ($KeyValuePair in $Output) {
      $ThisValue = '{0} : {1}{2}' -f $KeyValuePair.Name.Trim(),$KeyValuePair.Value.Trim(),"`n"
      $null = $OutputStringBuilder.Append($ThisValue)
    }
    $Output = $OutputStringBuilder.ToString()
  } elseif ($OutCsv) {
    $null = $OutputStringBuilder = [System.Text.StringBuilder]::new()
    $null = $OutputNameLineStringBuilder = [System.Text.StringBuilder]::new()
    $null = $OutputValueLineStringBuilder = [System.Text.StringBuilder]::new()
    foreach ($KeyValuePair in $Output) {
      if($KeyValuePair.Name -like "*,*"){
        $KeyValuePair.Name = "`"$($KeyValuePair.Name)`""
      }
      if($KeyValuePair.Value -like "*,*"){
        $KeyValuePair.Value = "`"$($KeyValuePair.Value)`""
      }
      $ThisNameLineString = '{0},' -f $KeyValuePair.Name.Trim()
      $OutputNameLineStringBuilder.Append($ThisNameLineString) | Out-Null
      $ThisValueLineString = '{0},' -f $KeyValuePair.Value.Trim()
      $OutputValueLineStringBuilder.Append($ThisValueLineString) | Out-Null
    }
    $OutputStringBuilder.Append($OutputNameLineStringBuilder.ToString()) | Out-Null
    $OutputStringBuilder.AppendLine() | Out-Null
    $OutputStringBuilder.Append($OutputValueLineStringBuilder.ToString()) | Out-Null
    $null = $Output = $OutputStringBuilder.ToString()
  } elseif ($OutJson) {
    $Output = $Output | ConvertTo-Json
  }

  $Output
}

