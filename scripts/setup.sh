#!/usr/bin/env bash
set -euo pipefail

# ── Platform detection ───────────────────────────────────────────
OS="$(uname -s)"
case "$OS" in
  Darwin*)  PLATFORM="macos"  ;;
  Linux*)   PLATFORM="linux"  ;;
  CYGWIN*|MINGW*|MSYS*) PLATFORM="windows" ;;
  *)        PLATFORM="unknown" ;;
esac

# ── Colors & helpers ──────────────────────────────────────────────
# Disable colors if terminal doesn't support them or on older Windows CMD
if [ -t 1 ] && [ "${TERM:-dumb}" != "dumb" ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  CYAN='\033[0;36m'
  BOLD='\033[1m'
  DIM='\033[2m'
  RESET='\033[0m'
else
  RED='' GREEN='' YELLOW='' BLUE='' CYAN='' BOLD='' DIM='' RESET=''
fi

REPO="https://github.com/filiphric/ai-powered-quality-engineering-with-cursor.git"
DEFAULT_DIR="ai-powered-quality-engineering-with-cursor"
APP_DIR="trelloapp"
APP_PORT=3000
API_PORT=3001

cleanup() {
  printf "\n${YELLOW}Setup cancelled.${RESET}\n"
  exit 1
}
trap cleanup INT TERM

info()    { printf "${BLUE}  i${RESET}  %s\n" "$1"; }
success() { printf "${GREEN}  ✔${RESET}  %s\n" "$1"; }
error()   { printf "${RED}  ✖${RESET}  %s\n" "$1"; }
warn()    { printf "${YELLOW}  ⚠${RESET}  %s\n" "$1"; }

need_help() {
  printf "\n"
  printf "${YELLOW}${BOLD}  ── Need help? ─────────────────────────────────────────${RESET}\n"
  printf "\n"
  printf "  This often happens on work machines with restricted\n"
  printf "  permissions. Here's what you can do:\n"
  printf "\n"
  printf "  ${BOLD}1.${RESET} Ask your system administrator to install:\n"
  printf "     ${DIM}• git${RESET}\n"
  printf "     ${DIM}• Node.js v20 or later${RESET}\n"
  printf "     ${DIM}• npm (comes with Node.js)${RESET}\n"
  printf "\n"
  printf "  ${BOLD}2.${RESET} If your company uses a ${BOLD}VPN or proxy${RESET}, it may be\n"
  printf "     blocking downloads. Ask IT to allowlist:\n"
  printf "     ${DIM}• github.com${RESET}\n"
  printf "     ${DIM}• registry.npmjs.org${RESET}\n"
  printf "\n"
  printf "  ${BOLD}3.${RESET} Contact the ${BOLD}workshop instructor${RESET} — we'll help\n"
  printf "     you get set up before the session starts.\n"
  printf "\n"
}

spin() {
  local pid=$1 msg=$2
  local frames='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0
  while kill -0 "$pid" 2>/dev/null; do
    printf "\r  ${CYAN}%s${RESET}  %s" "${frames:i++%${#frames}:1}" "$msg"
    sleep 0.08
  done
  wait "$pid"
  return $?
}

WORKSHOP_COMMAND="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=workshop-app.sh
source "$SCRIPT_DIR/workshop-app.sh"

if [[ "$WORKSHOP_COMMAND" =~ ^(start|reset|check|verify)$ ]]; then
  run_workshop_command "$WORKSHOP_COMMAND"
  exit 0
fi

# ── Welcome banner ────────────────────────────────────────────────
printf "\n"
printf "${CYAN}${BOLD}  ┌──────────────────────────────────────────────────┐${RESET}\n"
printf "${CYAN}${BOLD}  │                                                  │${RESET}\n"
printf "${CYAN}${BOLD}  │${RESET}${BOLD}    AI-Powered QE with Cursor — Workshop Setup    ${CYAN}${BOLD}│${RESET}\n"
printf "${CYAN}${BOLD}  │                                                  │${RESET}\n"
printf "${CYAN}${BOLD}  └──────────────────────────────────────────────────┘${RESET}\n"
printf "\n"

# ── Check: git ────────────────────────────────────────────────────
if ! command -v git &>/dev/null; then
  error "git is not installed"
  printf "\n"
  printf "  Install git:\n"
  case "$PLATFORM" in
    macos)   printf "    ${DIM}brew install git${RESET}\n" ;;
    linux)   printf "    ${DIM}sudo apt install git${RESET}  (Debian/Ubuntu)\n"
             printf "    ${DIM}sudo dnf install git${RESET}  (Fedora)\n" ;;
    windows) printf "    ${DIM}Download from https://git-scm.com/download/win${RESET}\n"
             printf "    ${DIM}or: winget install Git.Git${RESET}\n" ;;
    *)       printf "    ${DIM}https://git-scm.com/downloads${RESET}\n" ;;
  esac
  need_help
  exit 1
fi
success "git found"

# ── Check: node ───────────────────────────────────────────────────
if ! command -v node &>/dev/null; then
  error "Node.js is not installed"
  printf "\n"
  if [ "$PLATFORM" = "windows" ]; then
    printf "  Install Node.js:\n"
    printf "    ${DIM}Download from https://nodejs.org${RESET}\n"
    printf "    ${DIM}or: winget install OpenJS.NodeJS.LTS${RESET}\n"
    printf "    ${DIM}or use nvm-windows: https://github.com/coreybutler/nvm-windows${RESET}\n"
  else
    printf "  Install Node.js using nvm (recommended):\n"
    printf "    ${DIM}curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash${RESET}\n"
    printf "    ${DIM}nvm install 20${RESET}\n"
    printf "\n"
    printf "  Or download directly from:\n"
    printf "    ${DIM}https://nodejs.org${RESET}\n"
  fi
  need_help
  exit 1
fi

# ── Check: node version >= 20 ────────────────────────────────────
NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
  error "Node.js v20+ is required (found v$(node -v | sed 's/v//'))"
  printf "\n"
  printf "  Upgrade Node.js:\n"
  if [ "$PLATFORM" = "windows" ]; then
    printf "    ${DIM}Download from https://nodejs.org${RESET}\n"
    printf "    ${DIM}or: winget install OpenJS.NodeJS.LTS${RESET}\n"
  elif command -v nvm &>/dev/null; then
    printf "    ${DIM}nvm install 20${RESET}\n"
    printf "    ${DIM}nvm use 20${RESET}\n"
  else
    printf "    ${DIM}curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash${RESET}\n"
    printf "    ${DIM}nvm install 20${RESET}\n"
  fi
  need_help
  exit 1
fi
success "Node.js v$(node -v | sed 's/v//') found"

# ── Check: npm ────────────────────────────────────────────────────
if ! command -v npm &>/dev/null; then
  error "npm is not installed"
  printf "  npm usually comes with Node.js. Try reinstalling Node.js.\n"
  need_help
  exit 1
fi
success "npm v$(npm -v) found"

# ── Check for workshop updates ──────────────────────────────────
if [ -f "$SCRIPT_DIR/check-update.sh" ]; then
  source "$SCRIPT_DIR/check-update.sh"
  check_for_update || true
fi

# ── Check: claude code ───────────────────────────────────────────
if command -v claude &>/dev/null; then
  CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "unknown")
  success "Claude Code found ($CLAUDE_VERSION)"
else
  warn "Claude Code is not installed"
  printf "  Claude Code is required for this workshop.\n"
  printf "\n"
  printf "  ${BOLD}Install Claude Code now? (Y/n)${RESET} "
  read -r INSTALL_CLAUDE || INSTALL_CLAUDE=""
  if [[ ! "$INSTALL_CLAUDE" =~ ^[Nn]$ ]]; then
    if [ "$PLATFORM" = "windows" ]; then
      info "On Windows, the recommended install method is PowerShell:"
      printf "    ${DIM}irm https://claude.ai/install.ps1 | iex${RESET}\n"
      printf "\n"
      printf "  Alternatively, you can use WinGet:\n"
      printf "    ${DIM}winget install Anthropic.ClaudeCode${RESET}\n"
      printf "\n"
      warn "Please run one of the commands above in a separate terminal, then continue."
    else
      info "Installing Claude Code..."
      if curl -fsSL https://claude.ai/install.sh | bash 2>&1; then
        success "Claude Code installed"
      else
        error "Claude Code installation failed"
        printf "\n"
        printf "  You can install manually:\n"
        printf "    ${DIM}curl -fsSL https://claude.ai/install.sh | bash${RESET}\n"
        printf "\n"
        printf "  Or with Homebrew (macOS):\n"
        printf "    ${DIM}brew install --cask claude-code${RESET}\n"
        printf "\n"
      fi
    fi
  else
    printf "\n"
    printf "  You can install it later:\n"
    case "$PLATFORM" in
      macos|linux)
        printf "    ${DIM}curl -fsSL https://claude.ai/install.sh | bash${RESET}\n" ;;
      windows)
        printf "    ${DIM}irm https://claude.ai/install.ps1 | iex${RESET}  (PowerShell)\n"
        printf "    ${DIM}winget install Anthropic.ClaudeCode${RESET}\n" ;;
    esac
    printf "\n"
  fi
fi

# ── Check: cursor ────────────────────────────────────────────────
CURSOR_FOUND=false
if command -v cursor &>/dev/null; then
  CURSOR_FOUND=true
elif [ "$PLATFORM" = "macos" ] && [ -d "/Applications/Cursor.app" ]; then
  CURSOR_FOUND=true
elif [ "$PLATFORM" = "windows" ] && command -v cmd.exe &>/dev/null; then
  # Check common Windows install locations via cmd
  cmd.exe /C "where cursor" &>/dev/null && CURSOR_FOUND=true
  if [ "$CURSOR_FOUND" = false ]; then
    LOCALAPPDATA_WIN=$(cmd.exe /C "echo %LOCALAPPDATA%" 2>/dev/null | tr -d '\r')
    LOCALAPPDATA_UNIX=$(echo "$LOCALAPPDATA_WIN" | sed 's|\\|/|g; s|^\([A-Za-z]\):|/\L\1|')
    [ -f "$LOCALAPPDATA_UNIX/Programs/cursor/Cursor.exe" ] && CURSOR_FOUND=true
  fi
elif [ "$PLATFORM" = "linux" ]; then
  [ -f "/usr/share/applications/cursor.desktop" ] || [ -f "$HOME/.local/share/applications/cursor.desktop" ] && CURSOR_FOUND=true
fi

if [ "$CURSOR_FOUND" = true ]; then
  success "Cursor found"
else
  warn "Cursor is not installed"
  printf "  Cursor is the recommended IDE for this workshop.\n"
  printf "  Download it from: ${DIM}https://cursor.com/download${RESET}\n"
  printf "\n"
fi

# ── Check: network connectivity ──────────────────────────────────
printf "\n"
info "Checking network connectivity..."

check_url() {
  local url=$1 label=$2
  local reachable=false

  if command -v curl &>/dev/null; then
    curl -fsSL --connect-timeout 5 --max-time 10 "$url" -o /dev/null 2>/dev/null && reachable=true
  else
    # Fallback: use Node.js to check connectivity (works on all platforms)
    node -e "
      const https = require('https');
      const req = https.get('$url', { timeout: 10000 }, (res) => { process.exit(0); });
      req.on('error', () => process.exit(1));
      req.on('timeout', () => { req.destroy(); process.exit(1); });
    " 2>/dev/null && reachable=true
  fi

  if [ "$reachable" = true ]; then
    success "$label is reachable"
    return 0
  else
    error "$label is NOT reachable"
    return 1
  fi
}

NETWORK_OK=true
check_url "https://github.com" "github.com" || NETWORK_OK=false
check_url "https://registry.npmjs.org" "registry.npmjs.org" || NETWORK_OK=false

if [ "$NETWORK_OK" = false ]; then
  warn "Some network checks failed"
  printf "\n"
  printf "  If you are behind a ${BOLD}VPN or corporate proxy${RESET}, you may\n"
  printf "  need to ask IT to allowlist the URLs above.\n"
  printf "\n"
  printf "  ${BOLD}Continue anyway? (y/N)${RESET} "
  read -r CONTINUE || CONTINUE=""
  if [[ ! "$CONTINUE" =~ ^[Yy]$ ]]; then
    need_help
    exit 1
  fi
fi

# ── Clone or locate the repository ───────────────────────────────
# If the script is piped from curl or run outside the repo, clone it first.
# If already inside the repo (trelloapp dir exists nearby), use that.

WORKSHOP_DIR=""

if [ -n "${BASH_SOURCE[0]:-}" ] && [ -d "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/$APP_DIR" ]; then
  # Running from inside the repo (script lives in scripts/ subdirectory)
  WORKSHOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
elif [ -d "./$APP_DIR" ]; then
  WORKSHOP_DIR="$(pwd)"
else
  # Need to clone the repo
  printf "\n"
  printf "  ${BOLD}Where should we set up the project?${RESET}\n"
  printf "  ${DIM}(default: ${DEFAULT_DIR})${RESET} "
  read -r DIR_NAME || DIR_NAME=""
  DIR_NAME="${DIR_NAME:-$DEFAULT_DIR}"

  if [ -d "$DIR_NAME" ]; then
    warn "Directory '${DIR_NAME}' already exists"
    printf "  ${BOLD}Overwrite it? (y/N)${RESET} "
    read -r OVERWRITE || OVERWRITE=""
    if [[ "$OVERWRITE" =~ ^[Yy]$ ]]; then
      rm -rf "$DIR_NAME"
    else
      printf "  ${BOLD}Enter a different name:${RESET} "
      read -r DIR_NAME || DIR_NAME=""
      if [ -z "$DIR_NAME" ]; then
        error "No directory name provided"
        exit 1
      fi
      if [ -d "$DIR_NAME" ]; then
        error "Directory '${DIR_NAME}' also exists. Please remove it and try again."
        exit 1
      fi
    fi
  fi

  info "Cloning workshop repository..."
  git clone "$REPO" "$DIR_NAME" &>/dev/null &
  CLONE_PID=$!
  spin $CLONE_PID "Cloning repository..."
  if [ $? -ne 0 ]; then
    printf "\r"
    error "Failed to clone repository"
    printf "  Check your internet connection and try again.\n"
    need_help
    exit 1
  fi
  printf "\r                                              \r"
  success "Repository cloned into ${DIR_NAME}"

  WORKSHOP_DIR="$(cd "$DIR_NAME" && pwd)"
fi

APP_PATH="$WORKSHOP_DIR/$APP_DIR"

if [ ! -d "$APP_PATH" ]; then
  error "Application directory '$APP_DIR' not found in $WORKSHOP_DIR"
  exit 1
fi
success "Application directory found"

# ── Install dependencies ─────────────────────────────────────────
printf "\n"
info "Installing application dependencies..."
npm install --prefix "$APP_PATH" --silent &>/dev/null &
NPM_PID=$!
spin $NPM_PID "Installing dependencies..."
if [ $? -ne 0 ]; then
  printf "\r"
  error "npm install failed"
  printf "  Try running manually: ${DIM}cd $APP_DIR && npm install${RESET}\n"
  need_help
  exit 1
fi
printf "\r                                              \r"
success "Dependencies installed"

# ── Copy .env file ───────────────────────────────────────────────
if [ ! -f "$APP_PATH/.env" ] && [ -f "$APP_PATH/.env_example" ]; then
  cp "$APP_PATH/.env_example" "$APP_PATH/.env"
  success ".env file created from .env_example"
elif [ -f "$APP_PATH/.env" ]; then
  success ".env file already exists"
fi

# ── Command menu ─────────────────────────────────────────────────
show_menu() {
  printf "\n"
  printf "${CYAN}${BOLD}  ── What would you like to do? ──${RESET}\n"
  printf "\n"
  printf "  ${BOLD}1${RESET}  Start the application\n"
  printf "  ${BOLD}2${RESET}  Reset the application (clear database)\n"
  printf "  ${BOLD}3${RESET}  Check ports (${APP_PORT} & ${API_PORT})\n"
  printf "  ${BOLD}4${RESET}  Verify setup\n"
  printf "  ${BOLD}5${RESET}  Exit\n"
  printf "\n"
  printf "  ${BOLD}Choose an option (1-5):${RESET} "
}

# ── Interactive menu loop ────────────────────────────────────────
printf "\n"
success "Setup complete!"

while true; do
  show_menu
  read -r CHOICE || CHOICE=""
  case "$CHOICE" in
    1) start_app ;;
    2) reset_app ;;
    3) check_ports ;;
    4) verify_setup ;;
    5)
      printf "\n"
      info "Happy testing!"
      printf "\n"
      exit 0
      ;;
    *)
      warn "Invalid option — please choose 1-5"
      ;;
  esac
done
