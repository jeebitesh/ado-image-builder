$ErrorActionPreference = 'Stop'

$zipFile = 'C:\projects\ado-vmss-sf-agent\runner.zip'
$extractPath = 'C:\projects\ado-vmss-sf-agent\output'
#$ignoreMatch = '(^|/)\.config$'
$match = '/(images|helpers)/'

[Environment]::CurrentDirectory = $extractPath

Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [System.IO.Compression.ZipFile]::OpenRead($zipFile)

$archive.Entries | ForEach-Object { if ($_.Name -ne '') { if ($_.FullName -match $match) { if ($newDirectory = [System.IO.Path]::GetDirectoryName($_.FullName)) { [void][System.IO.Directory]::CreateDirectory($newDirectory) } [System.IO.Path]::GetFullPath($_.FullName); [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $_.FullName, $false); } } }