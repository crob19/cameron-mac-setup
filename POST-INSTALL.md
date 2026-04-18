# Post-install checklist

Things the setup script can't automate. Work through these after running `./setup.sh`.

## Accounts & sign-ins

- [ ] Sign in to Apple ID (System Settings → Apple Account)
- [ ] Sign in to iCloud, iMessage, FaceTime
- [ ] App Store sign-in
- [ ] Bitwarden — unlock vault
- [ ] 1Password (if using) — unlock vault
- [ ] GitHub CLI: `gh auth status` (setup.sh prompts for this; verify it's logged in)
- [ ] Claude Code: run `claude` and authenticate
- [ ] Codex: launch the app and sign in
- [ ] OpenCode: authenticate on first run

## App-specific

- [ ] **Raycast** — sign in and enable Cloud Sync (Settings → Cloud Sync) to restore extensions, hotkeys, snippets, quicklinks
- [ ] **Zed** — sign in for AI features and settings sync
- [ ] **Ghostty** — adjust theme / font if desired
- [ ] **Brave Browser** — sign in to sync bookmarks, extensions, passwords
- [ ] **Granola** — grant calendar + microphone permissions
- [ ] **Superwhisper** — grant microphone + accessibility permissions
- [ ] **Docker Desktop** — launch once to finish setup
- [ ] **Claude** desktop app — sign in
- [ ] **ChatGPT** desktop app — sign in

## System permissions

- [ ] Grant Terminal/Ghostty "Full Disk Access" (System Settings → Privacy & Security)
- [ ] Grant Raycast "Accessibility" permission
- [ ] Grant Superwhisper "Accessibility" + "Microphone"
- [ ] Enable Touch ID for `sudo` (optional): `sudo sh -c 'echo "auth sufficient pam_tid.so" >> /etc/pam.d/sudo_local'`

## Dev environment

- [ ] Source `nvm` in your shell: add to `~/.zshrc`:
  ```sh
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  ```
- [ ] `nvm install --lts` to install a Node LTS via nvm
- [ ] Set git identity (if not already):
  ```sh
  git config --global user.name "Your Name"
  git config --global user.email "you@example.com"
  ```
- [ ] Accept Xcode license: `sudo xcodebuild -license accept`

## Cloud storage

- [ ] OneDrive — sign in and start sync
- [ ] iCloud Drive — choose what to sync

## Misc

- [ ] Disable Siri if not used (System Settings → Siri & Spotlight)
- [ ] Set wallpaper
- [ ] Configure Hot Corners (System Settings → Desktop & Dock → Hot Corners)
