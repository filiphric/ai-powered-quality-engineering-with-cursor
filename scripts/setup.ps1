#Requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Command = ""
)

$ErrorActionPreference = "Stop"

$REPO      = "https://github.com/filiphric/ai-powered-quality-engineering-with-cursor.git"
$DEFAULT_DIR = "ai-powered-quality-engineering-with-cursor"
$APP_DIR   = "trelloapp"
$APP_PORT  = 3000
$API_PORT  = 3001

# ── Colors & helpers ─────────────────────────────────────────────
function Write-Info    { param($msg) Write-Host "  i  $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "  [OK]  $msg" -ForegroundColor Green }
function Write-Err     { param($msg) Write-Host "  X  $msg" -ForegroundColor Red }
function Write-Warn    { param($msg) Write-Host "  !  $msg" -ForegroundColor Yellow }

function Exit-Script {
    param([int]$code = 0)
    if ($code -ne 0) {
        Write-Host ""
        Read-Host "  Press Enter to close"
    }
    exit $code
}

function Show-NeedHelp {
    Write-Host ""
    Write-Host "  -- Need help? ------------------------------------------" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  This often happens on work machines with restricted"
    Write-Host "  permissions. Here's what you can do:"
    Write-Host ""
    Write-Host "  1. Ask your system administrator to install:"
    Write-Host "       git"
    Write-Host "       Node.js v20 or later"
    Write-Host "       npm (comes with Node.js)"
    Write-Host ""
    Write-Host "  2. If your company uses a VPN or proxy, it may be"
    Write-Host "       blocking downloads. Ask IT to allowlist:"
    Write-Host "       github.com"
    Write-Host "       registry.npmjs.org"
    Write-Host ""
    Write-Host "  3. Contact the workshop instructor -- we'll help"
    Write-Host "       you get set up before the session starts."
    Write-Host ""
}

function Show-Spinner {
    param([System.Diagnostics.Process]$proc, [string]$msg)
    $frames = @('|', '/', '-', '\')
    $i = 0
    while (-not $proc.HasExited) {
        Write-Host -NoNewline "`r  $($frames[$i % 4])  $msg"
        Start-Sleep -Milliseconds 80
        $i++
    }
    Write-Host -NoNewline "`r"
}

# ── Welcome banner ────────────────────────────────────────────────
Write-Host ""
Write-Host "  +------------------------------------------+" -ForegroundColor Cyan
Write-Host "  |                                          |" -ForegroundColor Cyan
Write-Host "  |   AI Workflows for QE -- Workshop Setup  |" -ForegroundColor Cyan
Write-Host "  |                                          |" -ForegroundColor Cyan
Write-Host "  +------------------------------------------+" -ForegroundColor Cyan
Write-Host ""

# ── Check: git ────────────────────────────────────────────────────
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Err "git is not installed"
    Write-Host ""
    Write-Host "  Install git:"
    Write-Host "    winget install Git.Git"
    Write-Host "    or download from https://git-scm.com/download/win"
    Show-NeedHelp
    Exit-Script 1
}
Write-Success "git found"

# ── Check: node ───────────────────────────────────────────────────
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Err "Node.js is not installed"
    Write-Host ""
    Write-Host "  Install Node.js:"
    Write-Host "    winget install OpenJS.NodeJS.LTS"
    Write-Host "    or download from https://nodejs.org"
    Show-NeedHelp
    Exit-Script 1
}

# ── Check: node version >= 20 ────────────────────────────────────
$nodeVer = (node -v) -replace '^v', ''
$nodeMajor = [int]($nodeVer -split '\.')[0]
if ($nodeMajor -lt 20) {
    Write-Err "Node.js v20+ is required (found v$nodeVer)"
    Write-Host ""
    Write-Host "  Upgrade Node.js:"
    Write-Host "    winget install OpenJS.NodeJS.LTS"
    Write-Host "    or download from https://nodejs.org"
    Show-NeedHelp
    Exit-Script 1
}
Write-Success "Node.js v$nodeVer found"

# ── Check: npm ────────────────────────────────────────────────────
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Err "npm is not installed"
    Write-Host "  npm usually comes with Node.js. Try reinstalling Node.js."
    Show-NeedHelp
    Exit-Script 1
}
$npmVer = npm -v
Write-Success "npm v$npmVer found"

# ── Check: claude code ───────────────────────────────────────────
if (Get-Command claude -ErrorAction SilentlyContinue) {
    $claudeVer = claude --version 2>$null
    Write-Success "Claude Code found ($claudeVer)"
} else {
    Write-Warn "Claude Code is not installed"
    Write-Host "  Claude Code is required for this workshop."
    Write-Host ""
    $installClaude = Read-Host "  Install Claude Code now? (Y/n)"
    if ($installClaude -notmatch '^[Nn]') {
        Write-Info "Installing Claude Code..."
        try {
            Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression
            Write-Success "Claude Code installed"
        } catch {
            Write-Err "Claude Code installation failed"
            Write-Host ""
            Write-Host "  You can install manually:"
            Write-Host "    irm https://claude.ai/install.ps1 | iex"
            Write-Host "    or: winget install Anthropic.ClaudeCode"
            Write-Host ""
        }
    } else {
        Write-Host ""
        Write-Host "  You can install it later:"
        Write-Host "    irm https://claude.ai/install.ps1 | iex"
        Write-Host "    or: winget install Anthropic.ClaudeCode"
        Write-Host ""
    }
}

# ── Check: cursor ────────────────────────────────────────────────
$cursorFound = $false
if (Get-Command cursor -ErrorAction SilentlyContinue) {
    $cursorFound = $true
} elseif (Test-Path "$env:LOCALAPPDATA\Programs\cursor\Cursor.exe") {
    $cursorFound = $true
}

if ($cursorFound) {
    Write-Success "Cursor found"
} else {
    Write-Warn "Cursor is not installed"
    Write-Host "  Cursor is the recommended IDE for this workshop."
    Write-Host "  Download it from: https://cursor.com/download"
    Write-Host ""
}

# ── Check: network connectivity ──────────────────────────────────
Write-Host ""
Write-Info "Checking network connectivity..."

function Test-Url {
    param([string]$url, [string]$label)
    try {
        $null = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
        Write-Success "$label is reachable"
        return $true
    } catch {
        Write-Err "$label is NOT reachable"
        return $false
    }
}

$networkOk = $true
if (-not (Test-Url "https://github.com" "github.com"))         { $networkOk = $false }
if (-not (Test-Url "https://registry.npmjs.org" "registry.npmjs.org")) { $networkOk = $false }

if (-not $networkOk) {
    Write-Warn "Some network checks failed"
    Write-Host ""
    Write-Host "  If you are behind a VPN or corporate proxy, you may"
    Write-Host "  need to ask IT to allowlist the URLs above."
    Write-Host ""
    $cont = Read-Host "  Continue anyway? (y/N)"
    if ($cont -notmatch '^[Yy]') {
        Show-NeedHelp
        Exit-Script 1
    }
}

# ── Clone or locate the repository ───────────────────────────────
$workshopDir = ""
if ($PSCommandPath) {
    $repoRoot = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
} else {
    # Running via irm | iex — no script file path available, use current directory
    $repoRoot = Get-Location
}

if (Test-Path (Join-Path $repoRoot $APP_DIR)) {
    $workshopDir = $repoRoot
} elseif (Test-Path (Join-Path (Get-Location) $APP_DIR)) {
    $workshopDir = Get-Location
} else {
    Write-Host ""
    $dirName = Read-Host "  Where should we set up the project? (default: $DEFAULT_DIR)"
    if ([string]::IsNullOrWhiteSpace($dirName)) { $dirName = $DEFAULT_DIR }

    if (Test-Path $dirName) {
        Write-Warn "Directory '$dirName' already exists"
        $overwrite = Read-Host "  Overwrite it? (y/N)"
        if ($overwrite -match '^[Yy]') {
            Remove-Item -Recurse -Force $dirName
        } else {
            $dirName = Read-Host "  Enter a different name"
            if ([string]::IsNullOrWhiteSpace($dirName)) {
                Write-Err "No directory name provided"
                Exit-Script 1
            }
            if (Test-Path $dirName) {
                Write-Err "Directory '$dirName' also exists. Please remove it and try again."
                Exit-Script 1
            }
        }
    }

    Write-Info "Cloning workshop repository..."
    & git clone $REPO $dirName
    if ($LASTEXITCODE -ne 0) {
        Write-Err "Failed to clone repository"
        Write-Host "  Check your internet connection and try again."
        Show-NeedHelp
        Exit-Script 1
    }
    Write-Success "Repository cloned into $dirName"
    $workshopDir = Join-Path (Get-Location) $dirName
}

$appPath = Join-Path $workshopDir $APP_DIR

if (-not (Test-Path $appPath)) {
    Write-Err "Application directory '$APP_DIR' not found in $workshopDir"
    Exit-Script 1
}
Write-Success "Application directory found"

# ── Install dependencies ─────────────────────────────────────────
Write-Host ""
Write-Info "Installing application dependencies..."
& npm install --prefix $appPath --silent
if ($LASTEXITCODE -ne 0) {
    Write-Err "npm install failed"
    Write-Host "  Try running manually: cd $APP_DIR && npm install"
    Show-NeedHelp
    Exit-Script 1
}
Write-Success "Dependencies installed"

# ── Copy .env file ───────────────────────────────────────────────
$envFile    = Join-Path $appPath ".env"
$envExample = Join-Path $appPath ".env_example"
if (-not (Test-Path $envFile) -and (Test-Path $envExample)) {
    Copy-Item $envExample $envFile
    Write-Success ".env file created from .env_example"
} elseif (Test-Path $envFile) {
    Write-Success ".env file already exists"
}

# ── Helper functions ─────────────────────────────────────────────
function Test-PortInUse {
    param([int]$port)
    $result = netstat -ano 2>$null | Select-String ":$port\s.*LISTENING"
    return $null -ne $result
}

function Get-PortPid {
    param([int]$port)
    $line = netstat -ano 2>$null | Select-String ":$port\s.*LISTENING" | Select-Object -First 1
    if ($line) { return ($line.ToString().Trim() -split '\s+')[-1] }
    return $null
}

function Start-App {
    foreach ($port in @($APP_PORT, $API_PORT)) {
        if (Test-PortInUse $port) {
            Write-Warn "Port $port is already in use"
            $free = Read-Host "  Free the ports first? (y/N)"
            if ($free -match '^[Yy]') {
                foreach ($p in @($APP_PORT, $API_PORT)) {
                    $pid = Get-PortPid $p
                    if ($pid) {
                        try { Stop-Process -Id $pid -Force; Write-Success "Freed port $p (killed PID $pid)" }
                        catch { Write-Warn "Could not kill PID $pid" }
                    }
                }
                Start-Sleep -Seconds 1
            }
            break
        }
    }

    Write-Info "Starting the application..."
    Write-Host "  App:  http://localhost:$APP_PORT" -ForegroundColor DarkGray
    Write-Host "  API:  http://localhost:$API_PORT" -ForegroundColor DarkGray
    Write-Host "  Press Ctrl+C to stop" -ForegroundColor DarkGray
    Write-Host ""
    Set-Location $appPath
    npm start
}

function Reset-App {
    Write-Info "Resetting application database..."
    $dbFile = Join-Path $appPath "backend\data\database.json"
    if (Test-Path $dbFile) {
        Set-Content $dbFile '{
  "boards": [],
  "cards": [],
  "lists": [],
  "users": []
}'
        Write-Success "Database reset to empty state"
    } else {
        Write-Err "Database file not found at $dbFile"
    }

    $uploadDir = Join-Path $appPath "backend\data\uploaded"
    if (Test-Path $uploadDir) {
        Get-ChildItem $uploadDir | Where-Object { $_.Name -ne ".gitkeep" } | Remove-Item -Force
        Write-Success "Uploaded files cleared"
    }
}

function Check-Ports {
    Write-Host ""
    foreach ($port in @($APP_PORT, $API_PORT)) {
        if (Test-PortInUse $port) {
            $pid = Get-PortPid $port
            if ($pid) { Write-Warn "Port $port is in use (PID $pid)" }
            else       { Write-Warn "Port $port is in use" }
        } else {
            Write-Success "Port $port is free"
        }
    }
}

function Verify-Setup {
    Write-Host ""
    Write-Info "Verifying setup..."
    $allOk = $true

    if (Test-Path (Join-Path $appPath "node_modules")) {
        Write-Success "node_modules installed"
    } else {
        Write-Err "node_modules missing -- run option 1 or 'cd $APP_DIR && npm install'"
        $allOk = $false
    }

    if (Test-Path (Join-Path $appPath ".env")) {
        Write-Success ".env file exists"
    } else {
        Write-Err ".env file missing"
        $allOk = $false
    }

    if (Test-Path (Join-Path $appPath "backend\data\database.json")) {
        Write-Success "Database file exists"
    } else {
        Write-Err "Database file missing"
        $allOk = $false
    }

    Check-Ports

    if ($allOk) {
        Write-Host ""
        Write-Success "Everything looks good!"
    } else {
        Write-Host ""
        Write-Warn "Some checks failed -- see errors above"
    }
}

# ── Parse command-line flags ─────────────────────────────────────
switch ($Command) {
    "start"  { Start-App;    Exit-Script 0 }
    "reset"  { Reset-App;    Exit-Script 0 }
    "check"  { Check-Ports;  Exit-Script 0 }
    "verify" { Verify-Setup; Exit-Script 0 }
}

# ── Interactive menu loop ────────────────────────────────────────
Write-Host ""
Write-Success "Setup complete!"

while ($true) {
    Write-Host ""
    Write-Host "  -- What would you like to do? --" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1  Start the application"
    Write-Host "  2  Reset the application (clear database)"
    Write-Host "  3  Check ports ($APP_PORT & $API_PORT)"
    Write-Host "  4  Verify setup"
    Write-Host "  5  Exit"
    Write-Host ""
    $choice = Read-Host "  Choose an option (1-5)"

    switch ($choice) {
        "1" { Start-App }
        "2" { Reset-App }
        "3" { Check-Ports }
        "4" { Verify-Setup }
        "5" {
            Write-Host ""
            Write-Info "Happy testing!"
            Write-Host ""
            Exit-Script 0
        }
        default { Write-Warn "Invalid option -- please choose 1-5" }
    }
}
