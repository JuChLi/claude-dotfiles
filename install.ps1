# Claude Dotfiles - Install Script (PowerShell)
# https://github.com/JuChLi/claude-dotfiles

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TargetDir = "$env:USERPROFILE\.claude\skills"

Write-Host "Installing Claude Code skills..."
Write-Host "Source: $ScriptDir\skills\"
Write-Host "Target: $TargetDir"
Write-Host ""

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

Get-ChildItem "$ScriptDir\skills" -Directory | ForEach-Object {
    $skillName = $_.Name
    $source = $_.FullName
    $dest = "$TargetDir\$skillName"
    if (Test-Path $dest) {
        Remove-Item $dest -Recurse -Force
    }
    New-Item -ItemType SymbolicLink -Path $dest -Target $source | Out-Null
    Write-Host "  /$skillName -> $source"
}

Write-Host ""
Write-Host "Done! Restart Claude Code or start a new session to use the skills." -ForegroundColor Green
