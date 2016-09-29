#Import .txt file with URLs in each line
#Outputs .csv file with status & Status code per URL
#
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$InputFile,
  [Parameter(Mandatory=$True,Position=2)]
  [string]$OutputFile
)

#$InputFile = 'C:\Temp\Input.txt'
#$OutputFile = 'C:\Temp\Output.csv'

cls
$ofs = ','
$urls = get-content $InputFile

'Status,StatusCode,URL'| Add-Content $OutputFile

foreach ($url in $urls)
{
$proxy = [System.Net.WebRequest]::GetSystemWebProxy()
$proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
$wc = new-object system.net.WebClient
$wc.proxy = $proxy
$webpage = $wc.DownloadData($url)
$wc = [system.Net.WebRequest]::Create($url)
$wc.method = "HEAD"

try {
       $res = $wc.GetResponse()
     } catch [System.Net.WebException] {
       $res = $_.Exception.Response
     }
finally
{
    if ($res -ne $null) { $res.Close() }
}
$Out = $res.StatusCode,[int]$res.StatusCode,$url
"$Out" | Add-Content $OutputFile
}