<#
.SYNOPSIS
    Scans Node.js project directories for known compromised Axios package versions.

.PARAMETER RootPath
    The root directory to recursively search for package.json files.
    Example: C:\Projects

.EXAMPLE
    .\Audit-AxiosPackages.ps1 -RootPath 'C:\Projects'

.NOTES
    Read-only. Does not modify any files or transmit data.
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$RootPath
)

$compromisedPackages = @(
    "axios@1.14.1",
    "axios@0.30.4",
    "plain-crypto-js@4.2.1"
)

$packageFiles = Get-ChildItem -Path $RootPath -Recurse -Filter "package.json" -ErrorAction SilentlyContinue

if (-not $packageFiles) {
    Write-Output "No package.json files found under $RootPath"
    exit
}

foreach ($file in $packageFiles) {
    $content    = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    $suspicious = $false

    foreach ($pkg in $compromisedPackages) {
        $name    = $pkg.Split("@")[0]
        $version = $pkg.Split("@")[1]

        if ($content -match [regex]::Escape($name) -and $content -match [regex]::Escape($version)) {
            Write-Output "SUSPICIOUS: $($file.FullName) — matched $pkg"
            $suspicious = $true
        }
    }

    if (-not $suspicious) {
        Write-Output "Clean:      $($file.FullName)"
    }
}
