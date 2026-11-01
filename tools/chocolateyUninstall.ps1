$ErrorActionPreference = 'Stop'

if (Get-Process -Name corneta -ErrorAction SilentlyContinue) {
    throw 'Close Corneta before uninstalling this package.'
}

$entries = @(Get-UninstallRegistryKey -SoftwareName 'Corneta')
if ($entries.Count -gt 1) {
    throw 'Multiple Corneta installations were found. Remove the intended installation through Windows Settings.'
}
if ($entries.Count -eq 1) {
    $uninstaller = $entries[0].UninstallString.Trim('"')
    if ([IO.Path]::GetFileName($uninstaller) -ne 'uninstall.exe' -or -not (Test-Path -LiteralPath $uninstaller -PathType Leaf)) {
        throw 'The registered Corneta uninstaller could not be verified.'
    }
    Uninstall-ChocolateyPackage -PackageName $env:ChocolateyPackageName -FileType 'exe' -SilentArgs '/S' -File $uninstaller -ValidExitCodes @(0)
}
