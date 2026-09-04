#!/bin/sh
#
# One-liner entrypoint for a fresh Mac. Clones this repo and runs install.sh.
#
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/henskjold73/personal-setup/main/bootstrap.sh)"
#   sh -c "$(wget -qO- https://raw.githubusercontent.com/henskjold73/personal-setup/main/bootstrap.sh)"
#
# To also import a specific Mac's snapshot right after install, append
# --import <macid> to the sh -c command, e.g.:
#   sh -c "$(curl -fsSL .../bootstrap.sh)" -- --import <macid>
#
set -e

REPO_URL="https://github.com/henskjold73/personal-setup.git"
TARGET_DIR="$HOME/personal-setup"

if ! command -v git >/dev/null 2>&1; then
  echo "git not found. Triggering Xcode Command Line Tools install (GUI prompt)..."
  xcode-select --install
  echo "Re-run this command once that finishes."
  exit 1
fi

if [ -d "$TARGET_DIR/.git" ]; then
  echo "==> Updating existing checkout at $TARGET_DIR"
  git -C "$TARGET_DIR" pull --ff-only
else
  echo "==> Cloning $REPO_URL to $TARGET_DIR"
  git clone "$REPO_URL" "$TARGET_DIR"
fi

exec /bin/bash "$TARGET_DIR/install.sh" "$@"