[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$Folder,
  [Parameter(Mandatory=$True,Position=2)]
  [string]$KeyValue,
  [Parameter(Mandatory=$True,Position=3)]
  [string]$OutputFile
)
#$Folder = "C:\Test"
#$KeyValue = "Name"
#$OutputFile = "C:\Namen.csv"

$ofs =','

cls
"Searching for $KeyValue in $Folder"
"--------------------------------------------------------------------------------------------"
"File,Value"| Add-Content $OutputFile

$files = get-childitem $Folder -Filter '*.xml' -rec

foreach ($file in $files)
{
Clear-Variable value

try{
$line = Select-String -path $file -pattern "<arr:Key>$KeyValue</arr:Key>" | ForEach-Object{ $_.lineNumber}

$extract = (get-Content $file.Fullname)[$line]

$found = $extract -match '.*>(.*)</Value>'
$Value = $matches[1]
"Schlüssel $KeyValue aus " + $file.Fullname + " extrahiert"
}
catch
{
"Schlüssel $KeyValue in " + $file.FullName + " nicht gefunden"
}
$Out = $file.FullName,$Value
[System.IO.File]::AppendAllText($OutputFile,$Out + ([Environment]::NewLine))
}
