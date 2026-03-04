#!/usr/bin/env bash
# Install packages from Brewfile

_brew_bundle_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="${_brew_bundle_dir}/../Brewfile"
unset _brew_bundle_dir

eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file="$BREWFILE"

# Rosetta 2 is needed by OrbStack for running x86 containers
softwareupdate --install-rosetta --agree-to-license
