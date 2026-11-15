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
    url64bit = 'https://github.com/pitroldev/corneta/releases/download/v0.14.0/Corneta_0.14.0_x64-setup.exe'
    checksum64 = '7d0773b9e13ed67b919730cee8fb6f4f356bb93e3edb6c276789ac01bb368e19'
    checksumType64 = 'sha256'
    silentArgs = '/S'
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
