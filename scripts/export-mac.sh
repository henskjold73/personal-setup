#!/usr/bin/env bash
#
# Snapshot this Mac's setup into macs/<macid>/ so it can be imported
# onto a new Mac later. Run this from an already-configured machine.
#
# Usage: scripts/export-mac.sh
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MACID="$("$DOTFILES_DIR/scripts/get-macid.sh")"
OUT="$DOTFILES_DIR/macs/$MACID"
mkdir -p "$OUT"

echo "==> Exporting snapshot for Mac $MACID"

cat > "$OUT/manifest.json" <<JSON
{
  "macid": "$MACID",
  "hostname": "$(scutil --get ComputerName 2>/dev/null || hostname)",
  "model": "$(sysctl -n hw.model 2>/dev/null || echo unknown)",
  "macos_version": "$(sw_vers -productVersion 2>/dev/null || echo unknown)",
  "exported_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
JSON

if command -v brew >/dev/null 2>&1; then
  echo "  - Homebrew packages"
  brew bundle dump --force --file="$OUT/Brewfile"
fi

if command -v code >/dev/null 2>&1; then
  echo "  - VS Code extensions"
  code --list-extensions > "$OUT/vscode-extensions.txt"
fi

if command -v npm >/dev/null 2>&1; then
  echo "  - npm global packages"
  npm ls -g --depth=0 --parseable 2>/dev/null | tail -n +2 | xargs -n1 basename > "$OUT/npm-global.txt" || true
fi

# Hand-edited dotfiles as they currently exist on this Mac, kept for
# reference/diffing — NOT auto-applied on import, since zsh/, hyper/,
# and vscode/ at the repo root remain the source of truth.
[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$OUT/.zshrc.local"
[ -f "$HOME/.hyper.js" ] && cp "$HOME/.hyper.js" "$OUT/.hyper.js.local"
[ -f "$HOME/.config/starship.toml" ] && cp "$HOME/.config/starship.toml" "$OUT/starship.toml.local"
VSCODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
[ -f "$VSCODE_SETTINGS" ] && cp "$VSCODE_SETTINGS" "$OUT/vscode-settings.json.local"

echo ""
echo "==> Snapshot written to macs/$MACID/"
echo "    Review the diff, then commit and push:"
echo "      git add macs/$MACID && git commit -m \"snapshot: $(scutil --get ComputerName 2>/dev/null || hostname)\" && git push"