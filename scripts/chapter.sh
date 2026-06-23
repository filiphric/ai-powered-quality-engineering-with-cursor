#!/usr/bin/env bash
set -euo pipefail

# ── Colors ───────────────────────────────────────────────────────
if [ -t 1 ] && [ "${TERM:-dumb}" != "dumb" ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  CYAN='\033[0;36m'
  BOLD='\033[1m'
  DIM='\033[2m'
  RESET='\033[0m'
else
  RED='' GREEN='' YELLOW='' CYAN='' BOLD='' DIM='' RESET=''
fi

# ── Check for workshop updates ──────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/check-update.sh"
check_for_update

CHAPTERS=(
  "01-cursor-basics"
  "02-rules"
  "03-skills"
  "04-context-engineering"
  "05-workflow-building"
  "06-ai-code-governance"
)

usage() {
  printf "\n"
  printf "${BOLD}  Usage:${RESET} npx workshop chapter <number>\n"
  printf "\n"
  printf "  ${BOLD}Available chapters:${RESET}\n"
  for ch in "${CHAPTERS[@]}"; do
    printf "    ${DIM}%s${RESET}\n" "$ch"
  done
  printf "\n"
  printf "  ${BOLD}Example:${RESET} npx workshop chapter 3\n"
  printf "\n"
  exit 1
}

BRANCH=""

if [ -z "${1:-}" ]; then
  printf "\n"
  printf "  ${BOLD}Select a chapter:${RESET}\n\n"
  PS3="$(printf '  Enter number: ')"
  select ch in "${CHAPTERS[@]}"; do
    if [ -n "$ch" ]; then
      BRANCH="chapter/$ch"
      break
    else
      printf "  ${RED}Invalid selection, try again.${RESET}\n"
    fi
  done
else
  NUM=$(printf "%02d" "$1" 2>/dev/null) || usage
  for ch in "${CHAPTERS[@]}"; do
    if [[ "$ch" == "$NUM"* ]]; then
      BRANCH="chapter/$ch"
      break
    fi
  done
  if [ -z "$BRANCH" ]; then
    printf "${RED}  Chapter %s not found.${RESET}\n" "$1"
    usage
  fi
fi

# Stash any uncommitted changes
if ! git diff --quiet HEAD 2>/dev/null || ! git diff --cached --quiet HEAD 2>/dev/null; then
  printf "${YELLOW}  Stashing your uncommitted changes...${RESET}\n"
  git stash push -m "auto-stash before switching to $BRANCH"
fi

# Switch to the chapter branch
printf "  Switching to ${BOLD}%s${RESET}...\n" "$BRANCH"
git checkout "$BRANCH"

printf "${GREEN}  Ready! You're now on %s${RESET}\n" "$BRANCH"
printf "\n"
