#!/usr/bin/env bash
#
# Bootstrap script for new Mac setup.
# Usage: sh -c "$(curl -fsSL https://raw.githubusercontent.com/henskjold73/personal-setup/main/bootstrap.sh)"
#     or, if already cloned: ./install.sh [--import <macid>]
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

IMPORT_MACID=""
while [ $# -gt 0 ]; do
  case "$1" in
    --import)
      IMPORT_MACID="${2:-}"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

echo "==> Installing Xcode Command Line Tools (if missing)"
xcode-select -p >/dev/null 2>&1 || xcode-select --install

echo "==> Installing Homebrew (if missing)"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "==> Installing packages from Brewfile"
brew bundle --file="$DOTFILES_DIR/Brewfile"

echo "==> Installing Oh My Zsh (if missing)"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "==> Installing zsh plugins (autosuggestions, syntax-highlighting)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || \
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

echo "==> Installing Starship prompt"
curl -fsSL https://starship.rs/install.sh | sh -s -- -y

echo "==> Installing nvm"
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
else
  echo "  nvm already installed, skipping"
fi
# Load nvm into this script's shell so we can install a default Node version now
\. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default lts/*

echo "==> Symlinking dotfiles"
ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml" 2>/dev/null || \
  (mkdir -p "$HOME/.config" && ln -sf "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml")
mkdir -p "$HOME/Library/Application Support/Hyper"
ln -sf "$DOTFILES_DIR/hyper/.hyper.js" "$HOME/.hyper.js"

echo "==> Applying VS Code settings + extensions"
bash "$DOTFILES_DIR/scripts/setup-vscode.sh"

echo "==> Installing Claude Code"
bash "$DOTFILES_DIR/scripts/setup-claude.sh"

if [ -n "$IMPORT_MACID" ]; then
  echo "==> Importing snapshot from Mac: $IMPORT_MACID"
  bash "$DOTFILES_DIR/scripts/import-mac.sh" "$IMPORT_MACID"
else
  echo "==> Skipping mac-to-mac import (no --import <macid> given)."
  echo "    See available snapshots with: scripts/import-mac.sh list"
fi

echo ""
echo "Done. Restart your terminal (or run 'exec zsh') to pick up the new shell config."
echo ""
echo "Once this Mac is fully set up the way you like it, capture it for"
echo "future machines with: scripts/export-mac.sh"