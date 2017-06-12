#!/usr/bin/env bash
set -euo pipefail

# kill self if last shell exits

# start self from .zshrc on new shell

while :; do
  sleep 1
  clear

  echo '# global'
  ~/.zsh/robs/shelld/k8s-current-context.sh
  echo

  echo '# local'
  ~/.zsh/robs/shelld/shells.rb
  echo
done
