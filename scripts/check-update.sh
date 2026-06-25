#!/usr/bin/env bash
# Checks for a newer workshop version on GitHub.
# Source this file after colors are defined.
# Expects: WORKSHOP_DIR (or falls back to script-relative detection)
#           Color variables (YELLOW, BOLD, DIM, CYAN, RESET, GREEN)
# Provides: check_for_update()

check_for_update() {
  # Resolve workshop root
  local root="${WORKSHOP_DIR:-}"
  if [ -z "$root" ]; then
    # Try to detect from script location
    if [ -n "${BASH_SOURCE[1]:-}" ]; then
      root="$(cd "$(dirname "${BASH_SOURCE[1]}")/.." && pwd)"
    else
      root="$(cd "$(dirname "$0")/.." && pwd)"
    fi
  fi

  local pkg="$root/package.json"
  if [ ! -f "$pkg" ]; then
    return 0
  fi

  # Read local version from package.json (works without node)
  local local_version
  local_version=$(grep '"version"' "$pkg" | head -1 | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
  if [ -z "$local_version" ]; then
    return 0
  fi

  # Fetch latest release tag from GitHub (timeout quickly so it never blocks)
  local api_url="https://api.github.com/repos/filiphric/ai-powered-quality-engineering-with-cursor/releases/latest"
  local remote_version=""

  if command -v curl &>/dev/null; then
    remote_version=$(curl -fsSL --connect-timeout 3 --max-time 5 "$api_url" 2>/dev/null \
      | grep '"tag_name"' | head -1 | sed 's/.*"tag_name"[[:space:]]*:[[:space:]]*"v\{0,1\}\([^"]*\)".*/\1/' || true)
  elif command -v node &>/dev/null; then
    remote_version=$(node -e "
      const https = require('https');
      const req = https.get('$api_url', { headers: { 'User-Agent': 'workshop-cli' }, timeout: 5000 }, (res) => {
        let data = '';
        res.on('data', c => data += c);
        res.on('end', () => {
          try { console.log(JSON.parse(data).tag_name.replace(/^v/, '')); }
          catch(e) {}
        });
      });
      req.on('error', () => {});
      req.on('timeout', () => req.destroy());
    " 2>/dev/null || true)
  fi

  # If we couldn't fetch the remote version, skip silently
  if [ -z "$remote_version" ]; then
    return 0
  fi

  # Compare versions — skip if they're the same
  if [ "$local_version" = "$remote_version" ]; then
    return 0
  fi

  # Simple semver comparison using sort -V (available on macOS & Linux)
  local higher
  higher=$(printf '%s\n%s\n' "$local_version" "$remote_version" | sort -V 2>/dev/null | tail -1 || printf '%s' "$remote_version")
  if [ "$higher" = "$local_version" ]; then
    # Local is newer or equal — nothing to do
    return 0
  fi

  # Show update notification and offer to update
  printf "\n"
  printf "${YELLOW}${BOLD}  ┌──────────────────────────────────────────┐${RESET}\n"
  printf "${YELLOW}${BOLD}  │${RESET}${BOLD}   Update available: %s -> %s${RESET}" "$local_version" "$remote_version"
  local msg="   Update available: $local_version -> $remote_version"
  local pad=$(( 42 - ${#msg} ))
  printf "%*s" "$pad" ""
  printf "${YELLOW}${BOLD}│${RESET}\n"
  printf "${YELLOW}${BOLD}  └──────────────────────────────────────────┘${RESET}\n"
  printf "\n"
  printf "  ${BOLD}Update now? (Y/n)${RESET} "
  read -r DO_UPDATE || DO_UPDATE=""
  if [[ "$DO_UPDATE" =~ ^[Nn]$ ]]; then
    return 0
  fi

  # Stash uncommitted changes if any
  local stashed=false
  if ! git -C "$root" diff --quiet HEAD 2>/dev/null || ! git -C "$root" diff --cached --quiet HEAD 2>/dev/null; then
    git -C "$root" stash push -m "auto-stash before workshop update to $remote_version" &>/dev/null
    stashed=true
    printf "  ${DIM}Stashed your local changes${RESET}\n"
  fi

  # Pull latest
  if git -C "$root" pull origin main --ff-only &>/dev/null; then
    printf "  ${GREEN}${BOLD}Updated to v%s${RESET}\n" "$remote_version"
  else
    printf "  ${YELLOW}Fast-forward failed — trying rebase...${RESET}\n"
    if git -C "$root" pull origin main --rebase &>/dev/null; then
      printf "  ${GREEN}${BOLD}Updated to v%s${RESET}\n" "$remote_version"
    else
      printf "  ${RED}Update failed.${RESET} You can update manually:\n"
      printf "    ${DIM}git pull origin main${RESET}\n"
      # Restore stash if we made one, so the user isn't left in a broken state
      if [ "$stashed" = true ]; then
        git -C "$root" stash pop &>/dev/null || true
      fi
      printf "\n"
      return 0
    fi
  fi

  # Reinstall dependencies in case they changed
  local app_path="$root/trelloapp"
  if [ -f "$app_path/package.json" ] && [ -d "$app_path/node_modules" ]; then
    printf "  ${DIM}Updating dependencies...${RESET}\n"
    npm install --prefix "$app_path" --silent &>/dev/null || true
  fi

  # Restore stashed changes
  if [ "$stashed" = true ]; then
    if git -C "$root" stash pop &>/dev/null; then
      printf "  ${GREEN}Restored your local changes${RESET}\n"
    else
      printf "  ${YELLOW}Could not auto-restore your changes.${RESET}\n"
      printf "  Run ${DIM}git stash pop${RESET} to restore them manually.\n"
    fi
  fi

  printf "\n"
}
