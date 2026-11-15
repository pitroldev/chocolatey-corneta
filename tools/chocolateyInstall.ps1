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
    url64bit = 'https://github.com/pitroldev/corneta/releases/download/v0.13.3/Corneta_0.13.3_x64-setup.exe'
    checksum64 = '6eb3b021a635bb37a7b4b02d435137d0f6ba444c61c4410426c6db5bf7c5b288'
    checksumType64 = 'sha256'
    silentArgs = '/S'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
