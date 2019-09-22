#!/usr/bin/env bash
set -euo pipefail

test -d ~/.shelld/global/ || mkdir -vp ~/.shelld/global
test -d ~/.shelld/shells/ || mkdir -vp ~/.shelld/shells

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
