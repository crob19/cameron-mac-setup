#!/usr/bin/env bash
# Configure macOS login items (apps that auto-launch on login).
set -euo pipefail

log() { printf "\n\033[1;34m==>\033[0m %s\n" "$*"; }

apps=(
  "/Applications/Raycast.app"
  "/Applications/Granola.app"
  "/Applications/Warp.app"
  # Add more as needed; entries below are optional and skipped if missing:
  # "/Applications/Dropbox.app"
  # "/Applications/Figma.app"
)

for app in "${apps[@]}"; do
  if [[ ! -d "$app" ]]; then
    echo "skip: $app not installed"
    continue
  fi
  name="$(basename "$app" .app)"
  # Idempotent: remove then re-add
  osascript <<EOF >/dev/null
tell application "System Events"
  if exists login item "$name" then
    delete login item "$name"
  end if
  make login item at end with properties {path:"$app", hidden:false}
end tell
EOF
  log "Added login item: $name"
done
