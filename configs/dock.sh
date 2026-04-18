#!/usr/bin/env bash
# Configure the Dock. Requires `dockutil` (installed via Brewfile).
set -euo pipefail

log() { printf "\n\033[1;34m==>\033[0m %s\n" "$*"; }

if ! command -v dockutil >/dev/null 2>&1; then
  echo "dockutil not found — skipping dock setup"
  exit 0
fi

log "Clearing existing Dock items"
dockutil --remove all --no-restart

# Ordered list of apps to pin. Adjust to taste.
apps=(
  "/System/Applications/Launchpad.app"
  "/System/Applications/Reminders.app"
  "/System/Applications/Notes.app"
  "/System/Applications/System Settings.app"
)

for app in "${apps[@]}"; do
  if [[ -d "$app" ]]; then
    dockutil --add "$app" --no-restart
  else
    echo "skip: $app not found"
  fi
done

# Sensible dock defaults
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false

log "Restarting Dock"
killall Dock
