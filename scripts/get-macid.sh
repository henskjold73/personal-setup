#!/usr/bin/env bash
# Prints a stable identifier for this Mac (hardware UUID), used as the
# folder name under macs/<macid>/. Falls back to hostname if unavailable.
set -euo pipefail

if command -v ioreg >/dev/null 2>&1; then
  uuid="$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformUUID/{print $4; exit}')"
  if [ -n "${uuid:-}" ]; then
    echo "$uuid"
    exit 0
  fi
fi

# Fallback: sanitized hostname
scutil --get ComputerName 2>/dev/null | tr ' ' '-' | tr '[:upper:]' '[:lower:]' || hostname