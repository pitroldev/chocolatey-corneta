$ErrorActionPreference = 'Stop'
$version = ([xml](Get-Content -Raw (Join-Path $PSScriptRoot '../corneta.nuspec'))).package.metadata.version
if ($version -notmatch '^\d+\.\d+\.\d+$') { throw 'Invalid package version.' }
if ($env:RUNNER_ENVIRONMENT -ne 'github-hosted') {
    throw 'This validation must only run on a disposable GitHub-hosted runner.'
}
$installDir = Join-Path $env:LOCALAPPDATA 'Corneta'
$appDataDir = Join-Path $env:APPDATA 'br.com.pitroldev.corneta'
if ((Test-Path -LiteralPath $installDir) -or (Test-Path -LiteralPath $appDataDir)) {
    throw 'The runner already contains Corneta data.'
}
choco pack corneta.nuspec
if ($LASTEXITCODE -ne 0) { throw 'Package build failed.' }
$sources = "$PWD;https://community.chocolatey.org/api/v2/"
choco install corneta --version=$version --source=$sources --yes --no-progress
if ($LASTEXITCODE -notin @(0, 3010)) { throw "Installation failed: $LASTEXITCODE" }
$required = @('corneta.exe', 'ffmpeg.exe', 'mediamtx.exe', 'third-party/FFmpeg-LICENSE.txt', 'third-party/MediaMTX-LICENSE.txt')
foreach ($relative in $required) {
    if (-not (Test-Path -LiteralPath (Join-Path $installDir $relative))) { throw "Missing installed file: $relative" }
}
$actualVersion = (Get-Item -LiteralPath (Join-Path $installDir 'corneta.exe')).VersionInfo.ProductVersion
if ($actualVersion -ne $version) { throw "Unexpected installed version: $actualVersion" }
if (Get-Process -Name corneta -ErrorAction SilentlyContinue) { throw 'Silent installation unexpectedly launched Corneta.' }
New-Item -ItemType Directory -Path $appDataDir | Out-Null
$sentinel = Join-Path $appDataDir 'ci-retain.txt'
Set-Content -LiteralPath $sentinel -Value 'synthetic validation data'
choco upgrade corneta --version=$version --source=$sources --yes --force --no-progress
if ($LASTEXITCODE -notin @(0, 3010)) { throw "Reinstallation failed: $LASTEXITCODE" }
if (-not (Test-Path -LiteralPath $sentinel)) { throw 'Reinstallation removed application data.' }
choco uninstall corneta --yes --no-progress
if ($LASTEXITCODE -notin @(0, 1605, 1614, 3010)) { throw "Uninstallation failed: $LASTEXITCODE" }
$executable = Join-Path $installDir 'corneta.exe'
for ($attempt = 0; $attempt -lt 20 -and (Test-Path -LiteralPath $executable); $attempt++) {
    Start-Sleep -Milliseconds 500
}
foreach ($relative in @('corneta.exe', 'ffmpeg.exe', 'mediamtx.exe')) {
    if (Test-Path -LiteralPath (Join-Path $installDir $relative)) { throw "Uninstallation left binary: $relative" }
}
if (Test-Path -LiteralPath 'HKCU:/Software/Microsoft/Windows/CurrentVersion/Uninstall/Corneta') {
    throw 'Uninstallation left the Corneta uninstall registry entry.'
}
if (-not (Test-Path -LiteralPath $sentinel)) { throw 'Uninstallation removed application data.' }
if (Get-Process -Name corneta -ErrorAction SilentlyContinue) { throw 'Validation launched Corneta.' }
'Installation, same-version reinstallation, uninstallation, and data preservation passed.'
