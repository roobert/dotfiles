#!/usr/bin/env bash
# Checks for outdated tools and writes ~/.zsh_maintenance_required if updates exist
set -euo pipefail

MAINTENANCE_FILE="$HOME/.zsh_maintenance_required"

export PATH="/opt/homebrew/bin:$PATH"
eval "$(mise activate bash)"

updates=""

mise_outdated=$(mise outdated 2>/dev/null || true)
if [[ -n "$mise_outdated" ]]; then
  updates+="mise:\n${mise_outdated}\n\n"
fi

brew_outdated=$(brew outdated 2>/dev/null || true)
if [[ -n "$brew_outdated" ]]; then
  updates+="brew:\n${brew_outdated}\n"
fi

if [[ -n "$updates" ]]; then
  printf "%b" "$updates" > "$MAINTENANCE_FILE"
else
  rm -f "$MAINTENANCE_FILE"
fi
