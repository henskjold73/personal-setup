# --- Oh My Zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # disabled — Starship handles the prompt
plugins=(git zsh-autosuggestions zsh-syntax-highlighting node python npm)
source $ZSH/oh-my-zsh.sh

# --- Starship prompt ---
eval "$(starship init zsh)"

# --- Homebrew ---
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- PATH additions ---
export PATH="$HOME/.local/bin:$PATH"

# --- Editor ---
export EDITOR="code -w"

# --- Aliases ---
alias ll="ls -lah"
alias gs="git status"
alias gp="git pull"
alias cc="claude"

# --- Node / nvm ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"