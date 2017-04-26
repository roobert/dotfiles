#!/usr/bin/env bash

current_path="$(tmux display-message -p -F "#{pane_current_path}")"

repo=$(basename "$(git -C $current_path rev-parse --show-toplevel 2> /dev/null)")

if [[ -z ${repo} ]]; then
  exit
fi

branch=$(git rev-parse --abbrev-ref HEAD)

echo "${repo}/${branch} •"
