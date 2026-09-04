#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing Claude Code CLI via npm"
if ! command -v claude >/dev/null 2>&1; then
  npm install -g @anthropic-ai/claude-code
else
  echo "  claude already installed ($(claude --version 2>/dev/null || echo 'version unknown')), skipping"
fi

echo "==> Installing Claude Code VS Code extension"
if command -v code >/dev/null 2>&1; then
  code --install-extension anthropic.claude-code --force
else
  echo "  'code' CLI not found — install manually from the VS Code Marketplace once code CLI is on PATH."
fi

cat <<'EOF'

NOTE — Claude Desktop / Cowork:
The Claude desktop app (Chat + Cowork) installs automatically via the
Brewfile ("cask 'claude'"). Just sign in on first launch. Manual
download if needed: https://claude.com/download
EOF