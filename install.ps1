# Installs or updates Quarterdeck on Windows, then sets up what it uses:
# Claude Code, the deck MCP server, gh and glab.
#
#   irm https://raw.githubusercontent.com/paillardf/quarterdeck/main/install.ps1 | iex
#
# Run it again to update. Environment:
#   $env:QUARTERDECK_VERSION = 'v0.1.0'   install that release instead of the latest
#   $env:QUARTERDECK_YES = '1'            answer yes to every question
#   $env:QUARTERDECK_NO_LAUNCH = '1'      do not open the app at the end

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$Repo = 'paillardf/quarterdeck'
$Base = if ($env:QUARTERDECK_VERSION) { "https://github.com/$Repo/releases/download/$env:QUARTERDECK_VERSION" }
        else { "https://github.com/$Repo/releases/latest/download" }
$McpUrl = 'http://127.0.0.1:4777/mcp'
$Dest = Join-Path $env:LOCALAPPDATA 'Quarterdeck'
$Exe = Join-Path $Dest 'deck.exe'

function Say($m) { Write-Host "`n$m" -ForegroundColor White }
function Ok($m) { Write-Host "  + $m" -ForegroundColor Green }
function Warn($m) { Write-Host "  ! $m" -ForegroundColor Yellow }
function Has($c) { [bool](Get-Command $c -ErrorAction SilentlyContinue) }
function Ask($q) {
  if ($env:QUARTERDECK_YES) { return $true }
  try { $a = Read-Host "  $q [y/N]" } catch { return $false }
  return $a -match '^(y|yes)$'
}
function Refresh-Path {
  $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
              [Environment]::GetEnvironmentVariable('Path', 'User')
}

Say 'Installing Quarterdeck for Windows'
$zip = Join-Path $env:TEMP 'Quarterdeck-windows-x64.zip'
try { Invoke-WebRequest "$Base/Quarterdeck-windows-x64.zip" -OutFile $zip -UseBasicParsing }
catch { throw "Could not download $Base/Quarterdeck-windows-x64.zip" }

$running = Get-Process deck -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $Exe }
if ($running) { $running | Stop-Process -Force; Start-Sleep -Seconds 1; Ok 'Quit the running Quarterdeck' }
if (Test-Path $Dest) { Remove-Item $Dest -Recurse -Force }
Expand-Archive $zip -DestinationPath $Dest -Force
Remove-Item $zip
Get-ChildItem $Dest -Recurse -File | Unblock-File

$shell = New-Object -ComObject WScript.Shell
$lnk = $shell.CreateShortcut((Join-Path ([Environment]::GetFolderPath('Programs')) 'Quarterdeck.lnk'))
$lnk.TargetPath = $Exe
$lnk.WorkingDirectory = $Dest
$lnk.Save()
Ok "Installed $Dest, Start menu shortcut"

Say 'Setting up what Quarterdeck uses'
# Windows PowerShell turns a native command's stderr into an error under
# 'Stop'; from here on a failed check only prints a warning.
$ErrorActionPreference = 'Continue'

if (-not (Has claude)) {
  Warn 'Claude Code is missing. Quarterdeck runs every background task and Claude button through it.'
  if (Ask 'Install Claude Code now (official installer from claude.ai)?') {
    Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression
    Refresh-Path
    $env:Path += ";$env:USERPROFILE\.local\bin"
  }
}
if (Has claude) {
  Ok "Claude Code $((claude --version 2>$null | Select-Object -First 1))"
  # The deck MCP server lets any Claude Code session add todos and log activity.
  claude mcp get deck *> $null
  if ($LASTEXITCODE -eq 0) { Ok 'deck MCP server already registered' }
  else {
    claude mcp add --scope user --transport http deck $McpUrl *> $null
    if ($LASTEXITCODE -eq 0) { Ok "Registered the deck MCP server ($McpUrl) for all your Claude Code sessions" }
    else { Warn "Could not register the deck MCP server. Run: claude mcp add --scope user --transport http deck $McpUrl" }
  }
} else {
  Warn 'Install it later: https://claude.com/claude-code, then run this script again'
}

# Command, what it is for, winget id
foreach ($t in @(
    @('gh', 'GitHub pull requests, reviews and issues', 'GitHub.cli'),
    @('glab', 'GitLab merge requests, reviews and issues', 'GLab.GLab'))) {
  $cmd, $for, $id = $t
  if (-not (Has $cmd)) {
    if ((Has winget) -and (Ask "Install $cmd with winget ($for)?")) {
      winget install --id $id --exact --silent --accept-package-agreements --accept-source-agreements
      Refresh-Path
    }
    if (-not (Has $cmd)) { Warn "$cmd not found: only needed for $for"; continue }
  }
  & $cmd auth status *> $null
  if ($LASTEXITCODE -eq 0) { Ok "$cmd logged in" }
  elseif (Ask "$cmd is not logged in. Log in now?") { & $cmd auth login }
  else { Warn "$cmd is not logged in: run '$cmd auth login' to use $for" }
}

Say 'Last steps'
Write-Host '  1. Slack, Mail, Calendar and Jira use your claude.ai connectors. Connect the'
Write-Host '     ones you want at https://claude.ai/settings/connectors (Slack, Gmail,'
Write-Host '     Google Calendar, Atlassian).'
Write-Host '  2. In Quarterdeck: Settings > Providers, turn on what you use, then'
Write-Host '     Settings > Projects, add your project folders.'

if (-not $env:QUARTERDECK_NO_LAUNCH) {
  Start-Process $Exe -WorkingDirectory $Dest
  Say 'Quarterdeck is open.'
}
