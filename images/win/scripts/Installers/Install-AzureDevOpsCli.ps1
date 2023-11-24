################################################################################
##  File:  Install-AzureDevOpsCli.ps1
##  Desc:  Install Azure DevOps CLI
################################################################################

az extension add -n azure-devops
az aks install-cli
$targetDir = "$env:USERPROFILE\.azure-kubelogin"
$oldPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
$oldPathArray = ($oldPath) -split ";"
if (-Not($oldPathArray -Contains "$targetDir")) {
    Write-Host "Permanently adding $targetDir to User Path"
    $newPath = "$oldPath;$targetDir" -replace ";+", ";"
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "User"), [System.Environment]::GetEnvironmentVariable("Path", "Machine") -join ";"
}
Invoke-PesterTests -TestFile "CLI.Tools" -TestName "Azure DevOps CLI"