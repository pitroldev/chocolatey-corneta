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
    url64bit = 'https://github.com/pitroldev/corneta/releases/download/v0.15.1/Corneta_0.15.1_x64-setup.exe'
    checksum64 = 'fe398db3fff9fc98752d6cb9551d161ec0471a6e676527e348c89069057d653b'
    checksumType64 = 'sha256'
    silentArgs = '/S'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
