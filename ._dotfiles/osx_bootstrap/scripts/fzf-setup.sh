#!/usr/bin/env bash
# Set up fzf key bindings and completion

eval "$(/opt/homebrew/bin/brew shellenv)"
"$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
