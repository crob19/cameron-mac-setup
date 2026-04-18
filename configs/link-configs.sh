#!/usr/bin/env bash
# Symlink app config files from the repo into their expected locations.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

log() { printf "\n\033[1;34m==>\033[0m %s\n" "$*"; }

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -L "$dest" ]]; then
    rm "$dest"
  elif [[ -e "$dest" ]]; then
    mv "$dest" "$dest.backup.$(date +%s)"
    echo "backed up existing $dest"
  fi
  ln -s "$src" "$dest"
  echo "linked $dest -> $src"
}

# Zed
log "Linking Zed config"
link "$REPO_DIR/configs/zed/settings.json" "$HOME/.config/zed/settings.json"
link "$REPO_DIR/configs/zed/keymap.json"   "$HOME/.config/zed/keymap.json"

# Raycast: plist can't be symlinked (macOS rewrites it). Copy instead.
# Note: Raycast's cloud sync is the more reliable path — see POST-INSTALL.md.
if [[ -f "$REPO_DIR/configs/raycast.plist" ]]; then
  log "Copying Raycast preferences (app must be closed first)"
  if pgrep -x Raycast >/dev/null; then
    echo "Raycast is running — quit it and re-run this script to apply preferences."
  else
    cp "$REPO_DIR/configs/raycast.plist" "$HOME/Library/Preferences/com.raycast.macos.plist"
    defaults read com.raycast.macos >/dev/null  # refresh plist cache
  fi
fi
