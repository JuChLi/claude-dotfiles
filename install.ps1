# Claude Dotfiles - Install Script (PowerShell)
# https://github.com/JuChLi/claude-dotfiles

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TargetDir = "$env:USERPROFILE\.claude\skills"

Write-Host "Installing Claude Code skills..."
Write-Host "Source: $ScriptDir\skills\"
Write-Host "Target: $TargetDir"
Write-Host ""

Get-ChildItem "$ScriptDir\skills" -Directory | ForEach-Object {
    $skillName = $_.Name
    $dest = "$TargetDir\$skillName"
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    Copy-Item "$($_.FullName)\*" -Destination $dest -Force
    Write-Host "  /$skillName"
}

Write-Host ""
Write-Host "Done! Restart Claude Code or start a new session to use the skills." -ForegroundColor Green
