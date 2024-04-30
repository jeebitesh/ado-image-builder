################################################################################
##  File:  Install-Apache.ps1
##  Desc:  Install Apache HTTP Server
################################################################################

# Stop w3svc service
Stop-Service -Name w3svc | Out-Null

$installDir = "C:\tools"

Write-Host "Install the latest Azure CLI release"
$url = "https://www.apachelounge.com/download/VS17/binaries"
$package = "azure-cli.msi"

$apacheArchPath = Start-DownloadWithRetry -Url $url -Name $package

New-Item -Path $installDir -ItemType Directory -Force

# Extract the zip archive
Write-Host "Extracting Apache..."
Extract-7Zip -Path $apacheArchPath -DestinationPath $installDir

# Add cf to path
Add-MachinePathItem $installDir\Apache24\bin

Set-Location $installDir\Apache24\bin\
.\httpd.exe -k install -n "Apache"

# Stop and disable Apache service
Stop-Service -Name Apache
Set-Service Apache -StartupType Disabled

# Start w3svc service
Start-Service -Name w3svc | Out-Null

# Invoke Pester Tests
Invoke-PesterTests -TestFile "Apache"
