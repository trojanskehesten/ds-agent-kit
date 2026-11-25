<#
.SYNOPSIS
    Installs ds-agent-kit (.agent/) into a target project directory.

.DESCRIPTION
    Copies the .agent/ rules and skills from this repository into the specified
    project directory. Prints the version from VERSION and warns before
    overwriting any existing files unless -Force is provided.

.PARAMETER TargetProject
    Path to the target project root directory.

.PARAMETER Force
    Overwrite existing files in the target project without prompting.

.EXAMPLE
    .\install.ps1 -TargetProject "C:\Users\me\projects\my-ds-project"

.EXAMPLE
    .\install.ps1 "C:\Users\me\projects\my-ds-project" -Force
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$TargetProject,

    [switch]$Force
)

$ErrorActionPreference = "Stop"

$RepoRoot = $PSScriptRoot
$VersionFile = Join-Path $RepoRoot "VERSION"
$SourceAgentDir = Join-Path $RepoRoot ".agent"

if (-not (Test-Path -Path $VersionFile -PathType Leaf)) {
    Write-Error "VERSION file not found at '$VersionFile'."
    exit 1
}

if (-not (Test-Path -Path $SourceAgentDir -PathType Container)) {
    Write-Error "Source directory '.agent/' not found at '$SourceAgentDir'."
    exit 1
}

if (-not (Test-Path -Path $TargetProject -PathType Container)) {
    Write-Error "Target project directory does not exist: '$TargetProject'."
    exit 1
}

$Version = (Get-Content -Path $VersionFile -Raw).Trim()
$ResolvedTarget = (Resolve-Path -Path $TargetProject).Path
$DestAgentDir = Join-Path $ResolvedTarget ".agent"

Write-Host "ds-agent-kit v$Version" -ForegroundColor Cyan
Write-Host "Target: $DestAgentDir"

$SourceFiles = Get-ChildItem -Path $SourceAgentDir -File -Recurse
$Conflicts = @()

foreach ($File in $SourceFiles) {
    $RelativePath = $File.FullName.Substring($SourceAgentDir.Length).TrimStart('\', '/')
    $DestPath = Join-Path $DestAgentDir $RelativePath
    if (Test-Path -Path $DestPath -PathType Leaf) {
        $Conflicts += $RelativePath
    }
}

if ($Conflicts.Count -gt 0 -and -not $Force) {
    Write-Warning "The following $($Conflicts.Count) file(s) already exist in '$DestAgentDir':"
    foreach ($Item in $Conflicts) {
        Write-Host "  - .agent\$Item" -ForegroundColor Yellow
    }

    if (-not [Environment]::UserInteractive -or [Console]::IsInputRedirected) {
        Write-Error "Existing files detected in non-interactive mode. Re-run with -Force to overwrite."
        exit 1
    }

    $Response = Read-Host "Overwrite existing files? [y/N]"
    if ($Response -notin @("y", "Y", "yes", "YES")) {
        Write-Host "Installation cancelled. No files were modified." -ForegroundColor Yellow
        exit 0
    }
}

$CopiedCount = 0
foreach ($File in $SourceFiles) {
    $RelativePath = $File.FullName.Substring($SourceAgentDir.Length).TrimStart('\', '/')
    $DestPath = Join-Path $DestAgentDir $RelativePath
    $DestParent = Split-Path -Path $DestPath -Parent

    if (-not (Test-Path -Path $DestParent -PathType Container)) {
        New-Item -ItemType Directory -Path $DestParent -Force | Out-Null
    }

    Copy-Item -Path $File.FullName -Destination $DestPath -Force
    $CopiedCount++
}

Write-Host "Installed ds-agent-kit v$Version ($CopiedCount file(s)) to '$DestAgentDir'." -ForegroundColor Green
