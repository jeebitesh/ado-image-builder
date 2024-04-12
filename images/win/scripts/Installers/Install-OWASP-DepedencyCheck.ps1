################################################################################
##  File:  Install-OWASP-Depedency-Check.ps1
##  Desc:  Install OWASP-Depedency-Check for Windows
################################################################################

$OWASPDirectory = "C:\OWASP\"
New-Item -ItemType directory -Path $OWASPDirectory


$VERSION = $(Invoke-RestMethod https://jeremylong.github.io/DependencyCheck/current.txt)

$DownloadFilePattern = "dependency-check-$VERSION-release.zip"
$DownloadUrl = "https://github.com/jeremylong/DependencyCheck/releases/download/v$VERSION/$DownloadFilePattern"
Start-DownloadWithRetry -Url $DownloadUrl -Name $DownloadFilePattern -DownloadPath $OWASPDirectory
Write-Host "Download Depedency-Check archive"
$DestinationPath = Join-Path $OWASPDirectory "DependencyCheck"
New-Item -ItemType directory -Path $DestinationPath
$match = '/(bin|lib|)/'
[Environment]::CurrentDirectory = $extractPath
Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [System.IO.Compression.ZipFile]::OpenRead($zipFile)
$archive.Entries | ForEach-Object { if ($_.Name -ne '') {
        if ($_.FullName -match $match) {
            if ($newDirectory = [System.IO.Path]::GetDirectoryName($_.FullName)) { [void][System.IO.Directory]::CreateDirectory($newDirectory) } [System.IO.Path]::GetFullPath($_.FullName);
            [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $_.FullName, $false); 
        } 
    } }
Get-ChildItem -Path C:\\output -Recurse
Write-Host "Expand stack archive"
Extract-7Zip -Path $OWASPDirectory\$DownloadFilePattern -DestinationPath $DestinationPath

#Add-MachinePathItem -PathItem $DestinationPath
