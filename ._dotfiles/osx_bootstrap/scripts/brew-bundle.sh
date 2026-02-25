#!/usr/bin/env bash
# Install packages from Brewfile

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="${SCRIPT_DIR}/../Brewfile"

eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file="$BREWFILE"

# Rosetta 2 is needed by OrbStack for running x86 containers
softwareupdate --install-rosetta --agree-to-license
