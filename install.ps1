#!/usr/bin/env pwsh
# Install the wezterm dotfiles.
#
#   pwsh -File install.ps1                    # symlink (falls back to copy)
#   pwsh -File install.ps1 -Copy              # always copy
#   pwsh -File install.ps1 -ConfigDir DIR     # override target directory
#
# Works on Windows, Linux and macOS (requires PowerShell 7+).

[CmdletBinding()]
param(
    [switch]$Copy,
    [string]$ConfigDir
)

$ErrorActionPreference = 'Stop'

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not $ConfigDir) {
    if ($env:XDG_CONFIG_HOME) {
        $ConfigDir = Join-Path $env:XDG_CONFIG_HOME 'wezterm'
    } else {
        $ConfigDir = Join-Path (Join-Path $HOME '.config') 'wezterm'
    }
}
$ThemesDir = Join-Path $ConfigDir 'themes'

New-Item -ItemType Directory -Force -Path $ThemesDir | Out-Null

function Test-Exists($Path) {
    return [bool](Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue)
}

function Test-Symlink($Path) {
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
    if (-not $item) { return $false }
    return ($null -ne $item.LinkType) -or [bool]($item.Attributes -band [IO.FileAttributes]::ReparsePoint)
}

function Install-Item {
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Destination
    )

    $name = Split-Path -Leaf $Destination

    if (Test-Symlink $Destination) {
        Remove-Item -LiteralPath $Destination -Force
    } elseif (Test-Exists $Destination) {
        $same = (Get-FileHash -LiteralPath $Source).Hash -eq (Get-FileHash -LiteralPath $Destination).Hash
        if ($same) {
            Remove-Item -LiteralPath $Destination -Force
        } else {
            Write-Host "  backup  $name -> $name.bak"
            Move-Item -LiteralPath $Destination -Destination "$Destination.bak" -Force
        }
    }

    if (-not $Copy) {
        try {
            New-Item -ItemType SymbolicLink -Path $Destination -Target $Source -ErrorAction Stop | Out-Null
            Write-Host "  symlink $name"
            return
        } catch {
            Write-Warning "symlink failed for $name; copying instead"
        }
    }

    Copy-Item -LiteralPath $Source -Destination $Destination -Force
    Write-Host "  copy    $name"
}

Write-Host "Installing wezterm config to $ConfigDir"

Install-Item -Source (Join-Path $RepoDir '.wezterm.lua') -Destination (Join-Path $ConfigDir 'wezterm.lua')

Get-ChildItem -LiteralPath (Join-Path $RepoDir 'theme') -Filter '*.toml' | ForEach-Object {
    Install-Item -Source $_.FullName -Destination (Join-Path $ThemesDir $_.Name)
}

Write-Host 'Done.'

$legacy = Join-Path $HOME '.wezterm.lua'
if ((Test-Exists $legacy) -and -not (Test-Symlink $legacy)) {
    Write-Warning "$legacy still exists and is shadowed by $ConfigDir/wezterm.lua; you can remove it."
}
