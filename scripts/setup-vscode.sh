#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

mkdir -p "$VSCODE_USER_DIR"
ln -sf "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"

if command -v code >/dev/null 2>&1; then
  while read -r ext; do
    [ -n "$ext" ] && code --install-extension "$ext" --force
  done < "$DOTFILES_DIR/vscode/extensions.txt"
else
  echo "  'code' CLI not found on PATH yet — open VS Code once, run"
  echo "  Cmd+Shift+P > 'Shell Command: Install code command in PATH', then re-run this script."
fi