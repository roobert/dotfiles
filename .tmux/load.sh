#!/usr/bin/env bash
set -euo pipefail

tmux source-file $HOME/.tmux/main.conf

if [[ $HOSTNAME == "super" ]]; then
  tmux source-file $HOME/.tmux/super.conf
fi
