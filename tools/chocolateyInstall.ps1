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
    url64bit = 'https://github.com/pitroldev/corneta/releases/download/v0.13.2/Corneta_0.13.2_x64-setup.exe'
    checksum64 = 'ec1baab5b4300055580b3c721ee0ec7bc516f0dc9cfce7c1bac50d6415853d90'
    checksumType64 = 'sha256'
    silentArgs = '/S'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
