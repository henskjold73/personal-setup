# personal-setup

Personal Mac bootstrap: Hyper, zsh (Oh My Zsh + Starship), VS Code, Claude Code, Claude Desktop/Cowork — plus a way to carry a Mac's actual installed state (brew packages, VS Code extensions, npm globals) forward onto the next Mac.

## Quick start (brand-new Mac)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/henskjold73/personal-setup/main/bootstrap.sh)"

or with wget:

sh -c "$(wget -qO- https://raw.githubusercontent.com/henskjold73/personal-setup/main/bootstrap.sh)"

This clones the repo to ~/personal-setup and runs install.sh. Re-running it later just pulls latest and re-applies — every step checks for existing installs first.

To also pull in everything a specific previous Mac had, append --import <macid>:

sh -c "$(curl -fsSL https://raw.githubusercontent.com/henskjold73/personal-setup/main/bootstrap.sh)" -- --import <macid>

Or manually, once cloned:

cd ~/personal-setup
./install.sh --import <macid>

## Carrying setup between Macs (macs/<macid>/)

Each Mac gets its own folder under macs/, keyed by that Mac's hardware UUID. It's a snapshot of what's actually installed, separate from the repo's own templated configs (zsh/, hyper/, vscode/), which stay the shared source of truth.

On an already-configured Mac, capture its state:

scripts/export-mac.sh

Writes macs/<macid>/:

- manifest.json — hostname, model, macOS version, export date
- Brewfile — full brew bundle dump of that Mac's packages
- vscode-extensions.txt — installed extensions
- npm-global.txt — global npm packages
- \*.local files — that Mac's actual dotfiles as they currently sit on disk, for reference/diffing only, not auto-applied on import

Then commit and push:

git add macs/<macid> && git commit -m "snapshot: <hostname>" && git push

On a new Mac, pull one in:

scripts/import-mac.sh list # see available snapshots
scripts/import-mac.sh <macid> # brew bundle + VS Code extensions + npm globals from that Mac

(install.sh --import <macid> runs this automatically at the end of a full setup.)

## What install.sh sets up

| Tool                           | Method                      | Config                                              |
| ------------------------------ | --------------------------- | --------------------------------------------------- |
| Homebrew + CLI tools           | Brewfile                    | node, python, git, gh, dotnet-sdk, starship         |
| Hyper                          | cask + symlink              | hyper/.hyper.js — Tokyo Night theme, JetBrains Mono |
| zsh                            | Oh My Zsh + plugins         | zsh/.zshrc — autosuggestions, syntax-highlighting   |
| Prompt                         | Starship                    | starship.toml — Tokyo Night colors                  |
| VS Code                        | cask + symlink + extensions | vscode/settings.json, vscode/extensions.txt         |
| Claude Code                    | npm + VS Code ext           | scripts/setup-claude.sh                             |
| Claude Desktop (Chat + Cowork) | Homebrew cask               | sign in manually on first launch                    |

## Notes

- Re-running install.sh is safe — every step checks for existing installs before acting.
- If code isn't on PATH yet, open VS Code once and run "Shell Command: Install 'code' command in PATH", then re-run scripts/setup-vscode.sh.
- macid is the Mac's hardware UUID (stable across reinstalls/renames), not the hostname — see scripts/get-macid.sh.
