$ErrorActionPreference = 'Stop'

if (-not [Environment]::Is64BitOperatingSystem) {
    throw 'Corneta requires 64-bit Windows.'
}
if ([Environment]::OSVersion.Version -lt [Version]'10.0') {
    throw 'Corneta requires Windows 10 or newer.'
}
if (Get-Process -Name corneta -ErrorAction SilentlyContinue) {
    throw 'Close Corneta before installing or upgrading this package.'
}

$packageArgs = @{
    packageName = $env:ChocolateyPackageName
    fileType = 'exe'
    softwareName = 'Corneta'
    url64bit = 'https://github.com/pitroldev/corneta/releases/download/v0.13.1/Corneta_0.13.1_x64-setup.exe'
    checksum64 = 'e9ec5e78bcdf91f47a5770ed6f83f9601176875c84756f9a67a24519dbc52192'
    checksumType64 = 'sha256'
    silentArgs = '/S'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
