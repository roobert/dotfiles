#!/usr/bin/env bash

NO_REMOTE_TRACKING_SYMBOL="L"
BRANCH_SYMBOL="⎇ "
STAGED_SYMBOL="●"
CONFLICT_SYMBOL="✖"
CHANGED_SYMBOL="✚"
UNTRACKED_SYMBOL="…"
STASHED_SYMBOL="⚑"
CLEAN_SYMBOL="✔"
AHEAD_SYMBOL="↑·"
BEHIND_SYMBOL="↓·"
PREHASH_SYMBOL=":"

current_path="$(tmux display-message -p -F "#{pane_current_path}")"

repo=$(basename "$(git -C $current_path rev-parse --show-toplevel 2> /dev/null)")

if [[ -z ${repo} ]]; then
  exit
fi

branch=$(git -C $current_path rev-parse --abbrev-ref HEAD)

echo "${repo}/${branch} •"
