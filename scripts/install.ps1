# Claude Code Windows Install Script
# Run this script from the directory containing claude.exe.
#
# Usage:
#   .\install.ps1
#   .\install.ps1 -AddToPath -ContextMenu

param(
  [switch]$AddToPath,
  [switch]$ContextMenu
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$exePath = Join-Path $scriptDir "claude.exe"

if (-not (Test-Path $exePath)) {
  Write-Error "claude.exe not found in $scriptDir. Run 'bun run build' first."
  exit 1
}

Write-Host "Found: $exePath"

# Add to user PATH
if ($AddToPath) {
  $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
  if ($userPath -notlike "*$scriptDir*") {
    Write-Host "Adding $scriptDir to user PATH..."
    [Environment]::SetEnvironmentVariable(
      "Path",
      "$userPath;$scriptDir",
      "User"
    )
    $env:Path = "$env:Path;$scriptDir"
    Write-Host "Done. Restart your terminal for PATH changes to take effect."
  } else {
    Write-Host "Already in PATH."
  }
}

Write-Host ""
Write-Host "Installation complete. Start Windows Terminal and run: claude.exe"
Write-Host ""

if (-not $AddToPath) {
  Write-Host "Tip: Re-run with -AddToPath to add to your user PATH:"
  Write-Host "  .\install.ps1 -AddToPath"
}
