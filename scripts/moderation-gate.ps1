$ErrorActionPreference = 'Stop'
$uri = "https://community.chocolatey.org/api/v2/Packages(Id='corneta',Version='0.13.1')"
[xml]$metadata = (Invoke-WebRequest -Uri $uri -TimeoutSec 30).Content
$properties = $metadata.entry.properties
if ($properties.Version -ne '0.13.1') { throw 'Unexpected initial package metadata.' }
$approved = $properties.IsApproved.InnerText
if ($approved -notin @('true', 'false')) { throw 'Missing package approval status.' }
if ($approved -eq 'true') {
    'allowed=true' >> $env:GITHUB_OUTPUT
    return
}
if ($properties.PackageStatus -ne 'Submitted') {
    throw "The initial package needs maintainer attention: $($properties.PackageStatus)."
}
'allowed=false' >> $env:GITHUB_OUTPUT
$message = 'Waiting for Chocolatey to approve the initial Corneta 0.13.1 submission. New versions cannot be submitted until then. The scheduled workflow will check again automatically.'
Write-Output "::notice::$message"
$message >> $env:GITHUB_STEP_SUMMARY
'https://community.chocolatey.org/packages/corneta/0.13.1' >> $env:GITHUB_STEP_SUMMARY
