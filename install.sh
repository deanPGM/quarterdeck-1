#!/bin/sh
# Installs or updates Quarterdeck on macOS or Linux, then sets up what it uses:
# Claude Code, the deck MCP server, gh and glab.
#
#   curl -fsSL https://raw.githubusercontent.com/paillardf/quarterdeck/main/install.sh | sh
#
# Run it again to update. Environment:
#   QUARTERDECK_VERSION=v0.1.0   install that release instead of the latest
#   QUARTERDECK_YES=1            answer yes to every question
#   QUARTERDECK_NO_LAUNCH=1      do not open the app at the end
set -eu

REPO="paillardf/quarterdeck"
if [ -n "${QUARTERDECK_VERSION:-}" ]; then
  BASE="https://github.com/$REPO/releases/download/$QUARTERDECK_VERSION"
else
  BASE="https://github.com/$REPO/releases/latest/download"
fi
MCP_URL="http://127.0.0.1:4777/mcp"

say() { printf '\n\033[1m%s\033[0m\n' "$*"; }
ok() { printf '  \033[32m✓\033[0m %s\n' "$*"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$*"; }
die() { printf '\033[31mError:\033[0m %s\n' "$*" >&2; exit 1; }
has() { command -v "$1" >/dev/null 2>&1; }

# Questions go to the terminal: under `curl | sh` stdin is the script itself.
# No terminal (CI, piped) means no.
ask() {
  [ -n "${QUARTERDECK_YES:-}" ] && return 0
  { printf '  %s [y/N] ' "$1" > /dev/tty; } 2>/dev/null || return 1
  { read -r answer < /dev/tty; } 2>/dev/null || return 1
  case "$answer" in y | Y | yes | Yes) return 0 ;; *) return 1 ;; esac
}

fetch() {
  curl -fL --progress-bar -o "$2" "$BASE/$1" || die "Could not download $BASE/$1"
}

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

install_macos() {
  say "Installing Quarterdeck for macOS"
  fetch Quarterdeck-macos.dmg "$tmp/q.dmg"

  apps=/Applications
  [ -w "$apps" ] || { apps="$HOME/Applications"; mkdir -p "$apps"; }
  app="$apps/Quarterdeck.app"

  if pgrep -f "Quarterdeck.app/Contents/MacOS/Quarterdeck" >/dev/null 2>&1; then
    osascript -e 'tell application id "io.github.paillardf.quarterdeck" to quit' >/dev/null 2>&1 || true
    sleep 2
    pkill -f "Quarterdeck.app/Contents/MacOS/Quarterdeck" 2>/dev/null || true
    ok "Quit the running Quarterdeck"
  fi

  hdiutil attach -nobrowse -readonly -quiet -mountpoint "$tmp/mnt" "$tmp/q.dmg"
  rm -rf "$app"
  ditto "$tmp/mnt/Quarterdeck.app" "$app"
  hdiutil detach -quiet "$tmp/mnt" || true
  ok "Installed $app"
  LAUNCH="open \"$app\""
}

install_linux() {
  case "$(uname -m)" in
    x86_64 | amd64) ;;
    *) die "Only x86_64 Linux builds exist for now (this machine is $(uname -m))." ;;
  esac
  say "Installing Quarterdeck for Linux"
  fetch Quarterdeck-linux-x64.tar.gz "$tmp/q.tar.gz"

  data="${XDG_DATA_HOME:-$HOME/.local/share}"
  dest="$data/quarterdeck"
  bin="$HOME/.local/bin"

  pkill -f "$dest/deck" 2>/dev/null && ok "Quit the running Quarterdeck" || true
  rm -rf "$dest"
  mkdir -p "$dest" "$bin" "$data/applications"
  tar -xzf "$tmp/q.tar.gz" -C "$dest"
  ln -sf "$dest/deck" "$bin/quarterdeck"
  cat > "$data/applications/quarterdeck.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Quarterdeck
Comment=Everything on your plate
Exec=$dest/deck
Icon=$dest/data/app_icon.png
Terminal=false
Categories=Development;Office;
EOF
  ok "Installed $dest, command 'quarterdeck', app menu entry"

  case ":$PATH:" in *":$bin:"*) ;; *) warn "$bin is not on your PATH: add it to run 'quarterdeck' from a terminal" ;; esac
  missing=$(ldd "$dest/deck" 2>/dev/null | awk '/not found/ {print $1}' | tr '\n' ' ')
  if [ -n "$missing" ]; then
    warn "Missing libraries: $missing"
    warn "Debian/Ubuntu: sudo apt install libgtk-3-0 libnotify4 · Fedora: sudo dnf install gtk3 libnotify"
  fi
  LAUNCH="nohup \"$dest/deck\" >/dev/null 2>&1 &"
}

setup_claude() {
  if ! has claude; then
    warn "Claude Code is missing. Quarterdeck runs every background task and Claude button through it."
    if ask "Install Claude Code now (official installer from claude.ai)?"; then
      curl -fsSL https://claude.ai/install.sh | bash
      PATH="$HOME/.local/bin:$PATH"
    fi
  fi
  if ! has claude; then
    warn "Install it later: https://claude.com/claude-code, then run this script again"
    return
  fi
  ok "Claude Code $(claude --version 2>/dev/null | head -n 1)"

  # The deck MCP server lets any Claude Code session add todos and log activity.
  if claude mcp get deck >/dev/null 2>&1; then
    ok "deck MCP server already registered"
  elif claude mcp add --scope user --transport http deck "$MCP_URL" >/dev/null 2>&1; then
    ok "Registered the deck MCP server ($MCP_URL) for all your Claude Code sessions"
  else
    warn "Could not register the deck MCP server. Run: claude mcp add --scope user --transport http deck $MCP_URL"
  fi
}

# $1 command, $2 what it is for, $3 Homebrew formula
setup_cli() {
  if ! has "$1"; then
    if has brew && ask "Install $1 with Homebrew ($2)?"; then
      brew install "$3"
    else
      warn "$1 not found: only needed for $2"
      return
    fi
  fi
  if "$1" auth status >/dev/null 2>&1; then
    ok "$1 logged in"
  elif ask "$1 is not logged in. Log in now?"; then
    "$1" auth login < /dev/tty || warn "Log in later with: $1 auth login"
  else
    warn "$1 is not logged in: run '$1 auth login' to use $2"
  fi
}

case "$(uname -s)" in
  Darwin) install_macos ;;
  Linux) install_linux ;;
  *) die "Use install.ps1 on Windows: irm https://raw.githubusercontent.com/$REPO/main/install.ps1 | iex" ;;
esac

say "Setting up what Quarterdeck uses"
setup_claude
setup_cli gh "GitHub pull requests, reviews and issues" gh
setup_cli glab "GitLab merge requests, reviews and issues" glab

say "Last steps"
echo "  1. Slack, Mail, Calendar and Jira use your claude.ai connectors. Connect the"
echo "     ones you want at https://claude.ai/settings/connectors (Slack, Gmail,"
echo "     Google Calendar, Atlassian)."
echo "  2. In Quarterdeck: Settings › Providers, turn on what you use, then"
echo "     Settings › Projects, add your project folders."

if [ -z "${QUARTERDECK_NO_LAUNCH:-}" ]; then
  if [ "$(uname -s)" = Darwin ] || [ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]; then
    eval "$LAUNCH"
    say "Quarterdeck is open."
  fi
fi
