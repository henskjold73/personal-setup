#!/usr/bin/env bash
#
# Import a snapshot from macs/<macid>/ (created by export-mac.sh) onto
# this Mac — installs the same brew packages, VS Code extensions, and
# npm globals another Mac had.
#
# Usage:
#   scripts/import-mac.sh list          # show available snapshots
#   scripts/import-mac.sh <macid>       # apply one
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ $# -lt 1 ] || [ "$1" = "list" ]; then
  echo "Available Mac snapshots:"
  shopt -s nullglob
  for d in "$DOTFILES_DIR"/macs/*/; do
    [ -f "$d/manifest.json" ] || continue
    id="$(basename "$d")"
    host="$(grep -o '"hostname": *"[^"]*"' "$d/manifest.json" | cut -d'"' -f4)"
    model="$(grep -o '"model": *"[^"]*"' "$d/manifest.json" | cut -d'"' -f4)"
    echo "  $id  ($host, $model)"
  done
  exit 0
fi

MACID="$1"
SRC="$DOTFILES_DIR/macs/$MACID"
[ -d "$SRC" ] || { echo "No snapshot found for '$MACID'. Run 'scripts/import-mac.sh list' to see options."; exit 1; }

echo "==> Importing snapshot from $MACID"

if [ -f "$SRC/Brewfile" ] && command -v brew >/dev/null 2>&1; then
  echo "  - brew bundle (packages that Mac had)"
  brew bundle --file="$SRC/Brewfile"
fi

if [ -f "$SRC/vscode-extensions.txt" ] && command -v code >/dev/null 2>&1; then
  echo "  - VS Code extensions"
  while read -r ext; do
    [ -n "$ext" ] && code --install-extension "$ext" --force
  done < "$SRC/vscode-extensions.txt"
fi

if [ -f "$SRC/npm-global.txt" ] && command -v npm >/dev/null 2>&1; then
  echo "  - npm global packages"
  while read -r pkg; do
    [ -n "$pkg" ] && npm install -g "$pkg"
  done < "$SRC/npm-global.txt"
fi

echo ""
echo "Note: macs/$MACID/*.local files are that Mac's hand-edited dotfiles,"
echo "kept for reference/diffing only — NOT applied automatically, since"
echo "zsh/, hyper/, and vscode/ at the repo root are the source of truth."
echo "To compare: diff macs/$MACID/.zshrc.local $DOTFILES_DIR/zsh/.zshrc"