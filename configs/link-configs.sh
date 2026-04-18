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

# Dotfiles
log "Linking dotfiles"
link "$REPO_DIR/dotfiles/.zshrc"     "$HOME/.zshrc"
link "$REPO_DIR/dotfiles/.gitconfig" "$HOME/.gitconfig"

# Zed
log "Linking Zed config"
link "$REPO_DIR/configs/zed/settings.json" "$HOME/.config/zed/settings.json"
link "$REPO_DIR/configs/zed/keymap.json"   "$HOME/.config/zed/keymap.json"

# Raycast: hotkeys and settings live in an encrypted SQLite DB tied to
# Keychain, so they can't be synced via the repo. Use Raycast Cloud Sync.
