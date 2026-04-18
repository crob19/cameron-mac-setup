#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { printf "\n\033[1;34m==>\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[warn]\033[0m %s\n" "$*"; }

# ----------------------------------------------------------------------------
# Xcode Command Line Tools
# ----------------------------------------------------------------------------
if ! xcode-select -p >/dev/null 2>&1; then
  log "Installing Xcode Command Line Tools"
  xcode-select --install || true
  echo "Finish the GUI installer, then re-run this script."
  exit 0
fi

# ----------------------------------------------------------------------------
# Homebrew
# ----------------------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Put brew on PATH for Apple Silicon / Intel
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ----------------------------------------------------------------------------
# Brewfile (formulae + casks). brew bundle is idempotent.
# ----------------------------------------------------------------------------
log "Updating Homebrew"
brew update
brew upgrade
brew upgrade --cask --greedy || true

log "Installing Brewfile packages"
brew bundle --file="$SCRIPT_DIR/Brewfile"

# ----------------------------------------------------------------------------
# npm-based coding agents (Claude Code)
# ----------------------------------------------------------------------------
log "Installing/updating npm-based CLIs"
npm install -g npm@latest
npm install -g @anthropic-ai/claude-code@latest

# ----------------------------------------------------------------------------
# GitHub SSH setup
# ----------------------------------------------------------------------------
setup_github_ssh() {
  local key_path="$HOME/.ssh/id_ed25519"

  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  if [[ ! -f "$key_path" ]]; then
    log "Generating new SSH key"
    read -r -p "Email for SSH key: " email
    ssh-keygen -t ed25519 -C "$email" -f "$key_path" -N ""
  else
    echo "SSH key already exists at $key_path"
  fi

  # Configure ssh-agent + keychain
  if ! grep -q "Host github.com" "$HOME/.ssh/config" 2>/dev/null; then
    log "Writing ~/.ssh/config entry for GitHub"
    cat >> "$HOME/.ssh/config" <<EOF

Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $key_path
EOF
    chmod 600 "$HOME/.ssh/config"
  fi

  eval "$(ssh-agent -s)" >/dev/null
  ssh-add --apple-use-keychain "$key_path" 2>/dev/null || ssh-add "$key_path"

  # Upload to GitHub via gh
  if ! gh auth status >/dev/null 2>&1; then
    log "Logging into GitHub CLI"
    gh auth login -p ssh -h github.com -w
  fi

  local title
  title="$(hostname -s)-$(date +%Y%m%d)"
  if gh ssh-key list 2>/dev/null | grep -q "$(awk '{print $2}' "${key_path}.pub")"; then
    echo "SSH key already registered with GitHub"
  else
    log "Uploading SSH key to GitHub as '$title'"
    gh ssh-key add "${key_path}.pub" --title "$title"
  fi

  log "Testing GitHub SSH connection"
  ssh -T -o StrictHostKeyChecking=accept-new git@github.com || true
}

setup_github_ssh

log "Done."
