#!/usr/bin/env bash
set -euo pipefail

function git_dir? () {
  dir=$1

  if (cd $dir && git rev-parse --git-dir > /dev/null 2>&1); then
    echo -n true
  else
    echo -n false
  fi
}

function branch_for () {
  dir=$1
  (cd $dir && git rev-parse --abbrev-ref HEAD)
}

PID=${1}

# race condition
dir=$(cat ${HOME}/.shelld/${PID}/cwd)

git_file=${HOME}/.shelld/${PID}/git

if [[ $(git_dir? $dir) != "true" ]]; then
  echo -n > ${git_file}
  exit
fi

branch="$(branch_for $dir)"

cat << EOF > ${git_file}
GIT_CURRENT_BRANCH=${branch}
EOF
