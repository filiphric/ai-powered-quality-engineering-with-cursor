#!/usr/bin/env bash
# App lifecycle helpers for the workshop CLI (sourced by setup.sh).

resolve_workshop_paths() {
  if [ -n "${BASH_SOURCE[1]:-}" ] && [ -d "$(cd "$(dirname "${BASH_SOURCE[1]}")/.." && pwd)/$APP_DIR" ]; then
    WORKSHOP_DIR="$(cd "$(dirname "${BASH_SOURCE[1]}")/.." && pwd)"
  elif [ -d "./$APP_DIR" ]; then
    WORKSHOP_DIR="$(pwd)"
  else
    error "Workshop not found. Run setup first or cd into the workshop directory."
    exit 1
  fi

  APP_PATH="$WORKSHOP_DIR/$APP_DIR"

  if [ ! -d "$APP_PATH" ]; then
    error "Application directory '$APP_DIR' not found in $WORKSHOP_DIR"
    exit 1
  fi
}

port_in_use() {
  local port=$1
  if [ "$PLATFORM" = "windows" ]; then
    netstat -ano 2>/dev/null | grep -q "[:.]${port} .*LISTENING"
  elif command -v lsof &>/dev/null; then
    # Only match listening sockets — plain `lsof -i :port` false-positives on CLOSED connections
    lsof -nP -iTCP:"$port" -sTCP:LISTEN &>/dev/null
  elif command -v ss &>/dev/null; then
    ss -tlnp 2>/dev/null | grep -q ":${port} "
  else
    ! node -e "
      const net = require('net');
      const s = net.createServer();
      s.once('error', () => process.exit(1));
      s.listen($port, () => { s.close(); process.exit(0); });
    " 2>/dev/null
  fi
}

get_port_pid() {
  local port=$1
  if [ "$PLATFORM" = "windows" ]; then
    netstat -ano 2>/dev/null | grep "[:.]${port} .*LISTENING" | awk '{print $NF}' | head -1
  elif command -v lsof &>/dev/null; then
    lsof -nP -t -iTCP:"$port" -sTCP:LISTEN 2>/dev/null | head -1
  elif command -v ss &>/dev/null; then
    ss -tlnp 2>/dev/null | grep ":${port} " | sed -n 's/.*pid=\([0-9]*\).*/\1/p' | head -1
  fi
}

kill_port_process() {
  local pid=$1
  if [ "$PLATFORM" = "windows" ]; then
    taskkill //F //PID "$pid" &>/dev/null
  else
    kill "$pid" 2>/dev/null
  fi
}

free_busy_ports_if_needed() {
  local ports_busy=false

  for port in $APP_PORT $API_PORT; do
    if port_in_use "$port"; then
      warn "Port $port is already in use"
      ports_busy=true
    fi
  done

  if [ "$ports_busy" = false ]; then
    return 0
  fi

  local free_ports=""
  if [ -t 0 ]; then
    printf "  ${BOLD}Free the ports first? (y/N)${RESET} "
    read -r free_ports || free_ports=""
  fi

  if [[ ! "$free_ports" =~ ^[Yy]$ ]]; then
    error "Cannot start — ports $APP_PORT and/or $API_PORT are in use."
    printf "  Stop the existing process or run: ${DIM}npx workshop check${RESET}\n"
    exit 1
  fi

  for port in $APP_PORT $API_PORT; do
    local pid
    pid=$(get_port_pid "$port")
    if [ -n "$pid" ]; then
      kill_port_process "$pid" && success "Freed port $port (killed PID $pid)" || warn "Could not kill PID $pid"
    fi
  done
  sleep 1
}

start_app() {
  free_busy_ports_if_needed

  info "Starting the application..."
  printf "  ${DIM}App:     http://localhost:${APP_PORT}${RESET}\n"
  printf "  ${DIM}API:     http://localhost:${API_PORT}${RESET}\n"
  printf "  ${DIM}Press Ctrl+C to stop${RESET}\n"
  printf "\n"

  cd "$APP_PATH" && npm start
}

reset_app() {
  info "Resetting application database..."

  local DB_FILE="$APP_PATH/backend/data/database.json"
  if [ -f "$DB_FILE" ]; then
    cat > "$DB_FILE" <<'EOF'
{
  "boards": [],
  "cards": [],
  "lists": [],
  "users": []
}
EOF
    success "Database reset to empty state"
  else
    error "Database file not found at $DB_FILE"
  fi

  local UPLOAD_DIR="$APP_PATH/backend/data/uploaded"
  if [ -d "$UPLOAD_DIR" ]; then
    for f in "$UPLOAD_DIR"/*; do
      [ -f "$f" ] && [ "$(basename "$f")" != ".gitkeep" ] && rm -f "$f"
    done
    success "Uploaded files cleared"
  fi
}

check_ports() {
  printf "\n"
  for port in $APP_PORT $API_PORT; do
    if port_in_use "$port"; then
      local pid
      pid=$(get_port_pid "$port")
      if [ -n "$pid" ]; then
        warn "Port $port is in use (PID $pid)"
      else
        warn "Port $port is in use"
      fi
    else
      success "Port $port is free"
    fi
  done
}

verify_setup() {
  printf "\n"
  info "Verifying setup..."

  local all_ok=true

  if [ -d "$APP_PATH/node_modules" ]; then
    success "node_modules installed"
  else
    error "node_modules missing — run setup or 'cd $APP_DIR && npm install'"
    all_ok=false
  fi

  if [ -f "$APP_PATH/.env" ]; then
    success ".env file exists"
  else
    error ".env file missing"
    all_ok=false
  fi

  if [ -f "$APP_PATH/backend/data/database.json" ]; then
    success "Database file exists"
  else
    error "Database file missing"
    all_ok=false
  fi

  check_ports

  if [ "$all_ok" = true ]; then
    printf "\n"
    success "Everything looks good!"
  else
    printf "\n"
    warn "Some checks failed — see errors above"
  fi
}

run_workshop_command() {
  local command=$1
  resolve_workshop_paths

  case "$command" in
    start)
      if ! command -v npm &>/dev/null; then
        error "npm is not installed"
        exit 1
      fi
      if [ ! -f "$APP_PATH/.env" ] && [ -f "$APP_PATH/.env_example" ]; then
        cp "$APP_PATH/.env_example" "$APP_PATH/.env"
      fi
      start_app
      ;;
    reset)  reset_app ;;
    check)  check_ports ;;
    verify) verify_setup ;;
  esac
}
