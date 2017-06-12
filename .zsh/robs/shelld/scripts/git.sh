#!/usr/bin/env bash
set -euo pipefail

SHELLD_DIR="${HOME}/.shelld/shells"

function repo? () {
  dir=$1

  if (cd $dir && git rev-parse --git-dir > /dev/null 2>&1); then
    echo -n true
  else
    echo -n false
  fi
}

# FIXME: collect these in one go?
function branch () {
  dir=$1
  (cd $dir && git rev-parse --abbrev-ref HEAD)
}

function repository () {
  dir=$1
  (cd $dir && basename `git rev-parse --show-toplevel`)
}

PID=${1}

# race condition
dir=$(cat ${SHELLD_DIR}/${PID}/cwd)

git_file=${SHELLD_DIR}/${PID}/git

if [[ $(repo? $dir) != "true" ]]; then
  echo -n > ${git_file}
  exit
fi

branch="$(branch $dir)"
repo="$(repository $dir)"


cat << EOF > ${git_file}.new
GIT_CURRENT_BRANCH=${branch}
GIT_CURRENT_REPOSITORY=${branch}
EOF

mv -v ${git_file}.new ${git_file}
