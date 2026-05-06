param(
    [Parameter(Mandatory = $true)]
    [string]$BackendRepoUrl,

    [Parameter(Mandatory = $true)]
    [string]$FrontendRepoUrl,

    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

if (-not (Test-Path ".git")) {
    git init | Out-Null
}

$targets = @(
    @{ Path = "backend"; Url = $BackendRepoUrl },
    @{ Path = "frontend"; Url = $FrontendRepoUrl }
)

foreach ($target in $targets) {
    if (Test-Path $target.Path) {
        if (-not $Force) {
            throw "Path '$($target.Path)' already exists. Remove it first or rerun with -Force."
        }

        Remove-Item $target.Path -Recurse -Force
    }

    git submodule add $target.Url $target.Path
}

git submodule update --init --recursive

Write-Host "Submodules configured successfully."

