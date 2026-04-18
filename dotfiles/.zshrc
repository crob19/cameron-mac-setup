# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="af-magic"
CASE_SENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=13
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="dd/mm/yyyy"

plugins=(git macos z)
source $ZSH/oh-my-zsh.sh

# Locale
export LANG=en_GB.UTF-8

# Homebrew (Apple Silicon)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$HOME/.bin:$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Local pipx bins
export PATH="$PATH:$HOME/.local/bin"

# ---------------------------------------------------------------------------
# Functions
# ---------------------------------------------------------------------------

# Delete a git tag locally and on origin
deltag() {
  if [ -z "$1" ]; then
    echo "Usage: deltag <tag-name>"
    return 1
  fi
  git tag -d "$1"
  git push origin ":refs/tags/$1"
}

# Print local network IP
getLocalIp() {
  ping -c 1 "$(hostname).local" | grep "64 bytes" | awk '{print $4}' | rev | cut -c 2- | rev
}

# Build a docker image with a tag
dbuild() {
  if [ -z "$1" ]; then
    echo "Usage: dbuild <tag>"
    return 1
  fi
  docker build --tag "$1" .
}

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------

alias vizsh='vi ~/.zshrc'

# Git
alias ga='git add -A'
alias gs='git status'
alias gc='git commit -a -m'
alias gac='git add -A && git commit -a -m'
alias gce='git commit --amend'
alias gds='git diff --staged'
alias gpb='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
alias gog='git log'
alias gls='git ls-files . --ignored --exclude-standard --others'
alias gt='git for-each-ref --sort=creatordate --format "%(creatordate:short)    %(refname:short)" refs/tags'

# Python
alias rmpy='rm -rf .cache .coverage build dist htmlcov *.egg-info test-report.html'
alias venv='if [[ ! -d venv ]]; then echo "venv create"; python3 -m venv venv; fi; source venv/bin/activate'

# Docker
alias dlog='docker logs -f'
alias dps='docker ps -a'
alias dimg='docker images'
alias drmi='docker rmi -f'
alias drm='docker rm -f'
alias dqf='docker images -qf "dangling=true"'
alias ddqf='docker rmi -f $(docker images -qf "dangling=true")'
alias dclean='docker volume rm $(docker volume ls -qf dangling=true)'
