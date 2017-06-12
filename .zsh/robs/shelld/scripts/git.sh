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

function branch () {
  dir=$1
  (cd $dir && git rev-parse --abbrev-ref HEAD)
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

cat << EOF > ${git_file}.new
GIT_CURRENT_BRANCH=${branch}
EOF

mv -v ${git_file}.new ${git_file}
