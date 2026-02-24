#!/usr/bin/env bash
# Install packages from Brewfile

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="${SCRIPT_DIR}/../Brewfile"

eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file="$BREWFILE"
