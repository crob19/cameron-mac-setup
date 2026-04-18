# cameron-mac-setup

Bootstrap a new Mac with my preferred apps, CLI tools, and GitHub SSH config.

## Usage

```sh
git clone git@github.com:crob19/cameron-mac-setup.git
cd cameron-mac-setup
./setup.sh
```

The script is idempotent — safe to re-run.

## What it does

1. Installs Xcode Command Line Tools (if missing)
2. Installs Homebrew (if missing)
3. Runs `brew bundle` against the `Brewfile` (formulae + casks)
4. Installs `@anthropic-ai/claude-code` via npm
5. Generates an ed25519 SSH key, configures `~/.ssh/config`, adds it to the keychain, and uploads it to GitHub via `gh`

## Contents

- `Brewfile` — declarative list of formulae and casks
- `setup.sh` — bootstrap script
