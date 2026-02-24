#!/bin/bash
set -e

DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_GIT="/usr/bin/git --git-dir=$DOTFILES_DIR --work-tree=$HOME"

$DOTFILES_GIT config --local status.showUntrackedFiles no
$DOTFILES_GIT checkout -f
