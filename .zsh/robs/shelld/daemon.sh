#!/usr/bin/env bash
set -euo pipefail

while :; do
  if [[ "$(pgrep -U${USER} zsh | wc -l)" -eq 0 ]]; then
    break
  fi

  clear

  echo '# global'
  ~/.zsh/robs/shelld/k8s-current-context.sh
  echo

  echo '# local'
  ~/.zsh/robs/shelld/shells.rb
  echo
done

rm -v ~/.shelld/pid.lock
