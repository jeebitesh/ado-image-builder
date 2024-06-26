Write-Host "Set TLS1.2"
Set-ExecutionPolicy Bypass -Scope Process -Force; 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Invoke-Expression ((New-Object net.webclient).DownloadString('https://get.scoop.sh'))

Write-Host "Install chocolatey"
$chocoExePath = 'C:\ProgramData\Chocolatey\bin'

# Add to system PATH
$systemPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
$systemPath += ';' + $chocoExePath
[Environment]::SetEnvironmentVariable("PATH", $systemPath, [System.EnvironmentVariableTarget]::Machine)

# Update local process' path
$userPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
if ($userPath) {
    $env:Path = $systemPath + ";" + $userPath
} else {
    $env:Path = $systemPath
}

# Run the installer
Invoke-Expression ((New-Object net.webclient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Turn off confirmation
choco feature enable -n allowGlobalConfirmation

# Initialize environmental variable ChocolateyToolsLocation by invoking choco Get-ToolsLocation function
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force
Get-ToolsLocation
