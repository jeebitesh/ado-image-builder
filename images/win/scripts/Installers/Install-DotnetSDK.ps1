################################################################################
##  File:  Install-DotnetSDK.ps1
##  Desc:  Install all released versions of the dotnet sdk and populate package
##         cache.  Should run after VS and Node
################################################################################

# Set environment variables
Set-SystemVariable -SystemVariable DOTNET_MULTILEVEL_LOOKUP -Value "0"
Set-SystemVariable -SystemVariable DOTNET_NOLOGO -Value "1"
Set-SystemVariable -SystemVariable DOTNET_SKIP_FIRST_TIME_EXPERIENCE -Value "1"

[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor "Tls12"

#region "Functions"
function Get-SDKVersionsToInstall (
    $DotnetVersion
) {
    $releaseJson = "https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/${DotnetVersion}/releases.json"
    $releasesJsonPath = Start-DownloadWithRetry -Url $releaseJson -Name "releases-${DotnetVersion}.json"
    $currentReleases = Get-Content -Path $releasesJsonPath | ConvertFrom-Json
    # filtering out the preview/rc releases
    $currentReleases = $currentReleases.'releases' | Where-Object { !$_.'release-version'.Contains('-') }

    $sdks = @()
    ForEach ($release in $currentReleases) {
        $sdks += $release.'sdk'
        $sdks += $release.'sdks'
    }

    return $sdks.version | Sort-Object { [Version] $_ } -Unique `
    | Group-Object { $_.Substring(0, $_.LastIndexOf('.') + 2) } `
    | ForEach-Object { $_.Group[-1] }
}

function Invoke-Warmup (
    $SdkVersion
) {
    # warm up dotnet for first time experience
    $projectTypes = @('console', 'mstest', 'web', 'mvc', 'webapi')
    $projectTypes | ForEach-Object {
        $template = $_
        $projectPath = Join-Path -Path C:\temp -ChildPath $template
        New-Item -Path $projectPath -Force -ItemType Directory
        Push-Location -Path $projectPath
        & $env:ProgramFiles\dotnet\dotnet.exe new globaljson --sdk-version "$sdkVersion"
        & $env:ProgramFiles\dotnet\dotnet.exe new $template
        Pop-Location
        Remove-Item $projectPath -Force -Recurse
    }
}

function InstallSDKVersion (
    $SdkVersion,
    $Warmup
) {
    if (!(Test-Path -Path "C:\Program Files\dotnet\sdk\$sdkVersion")) {
        Write-Host "Installing dotnet $sdkVersion"
        .\dotnet-install.ps1 -Version $sdkVersion -InstallDir $(Join-Path -Path $env:ProgramFiles -ChildPath 'dotnet')
    } else {
        Write-Host "Sdk version $sdkVersion already installed"
    }

    if ($Warmup) {
        Invoke-Warmup -SdkVersion $SdkVersion
    }
}

function InstallAllValidSdks() {
    # Consider all channels except preview/eol channels.
    # Sort the channels in ascending order
    $dotnetToolset = (Get-ToolsetContent).dotnet
    $dotnetVersions = $dotnetToolset.versions
    $warmup = $dotnetToolset.warmup

    # Download installation script.
    $installationName = "dotnet-install.ps1"
    $installationUrl = "https://dot.net/v1/${installationName}"
    Start-DownloadWithRetry -Url $installationUrl -Name $installationName -DownloadPath ".\"

    ForEach ($dotnetVersion in $dotnetVersions) {
        $sdkVersionsToInstall = Get-SDKVersionsToInstall -DotnetVersion $dotnetVersion
        
        ForEach ($sdkVersion in $sdkVersionsToInstall) {
            InstallSDKVersion -SdkVersion $sdkVersion -Warmup $warmup
        }
    }
}

function InstallTools() {
    $dotnetTools = (Get-ToolsetContent).dotnet.tools

    ForEach ($dotnetTool in $dotnetTools) {
        dotnet tool install $($dotnetTool.name) --tool-path "C:\Users\Default\.dotnet\tools" --add-source https://api.nuget.org/v3/index.json | Out-Null
    }
}

function RunPostInstallationSteps() {
    # Add dotnet to PATH
    Add-MachinePathItem "C:\Program Files\dotnet"

    # Remove NuGet Folder
    $nugetPath = "$env:APPDATA\NuGet"
    if (Test-Path $nugetPath) {
        Remove-Item -Path $nugetPath -Force -Recurse
    }

    # Generate and copy new NuGet.Config config
    dotnet nuget list source | Out-Null
    Copy-Item -Path $nugetPath -Destination C:\Users\Default\AppData\Roaming -Force -Recurse

    # Add %USERPROFILE%\.dotnet\tools to USER PATH
    Add-DefaultPathItem "%USERPROFILE%\.dotnet\tools"
}
#endregion

InstallAllValidSdks
RunPostInstallationSteps
InstallTools

Invoke-PesterTests -TestFile "DotnetSDK"
