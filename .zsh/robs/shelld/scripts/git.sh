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

function stashes () {
  dir=$1
  (cd $dir && git stashes)
}

PID=${1}

# race condition
dir=$(cat ${SHELLD_DIR}/${PID}/cwd)

git_file=${SHELLD_DIR}/${PID}/git

if [[ $(repo? $dir) != "true" ]]; then
  rm ${git_file}
  exit
fi

#BRANCH=" %{$FG[060]%}"
#STAGED=" %{$fg[yellow]%}%{\u26ab%G%}"
#CONFLICTS=" %{$fg[red]%}%{\u2716%G%}"
#CHANGED=" %{$fg[blue]%}%{\u271a%G%}"
#BEHIND=" %{\u2193%G%}"
#AHEAD=" %{$FG[166]%}%{\u2191%G%}"
#UNTRACKED=" %{$fg[red]%}%{\u2717%G%}"
#CLEAN=" %{$FG[028]%}%{\u2713%G%}"


branch="$(branch $dir)"
repo="$(repository $dir)"
repo_stashes="$(stashes $dir)"

cat << EOF > ${git_file}.new
GIT_CURRENT_BRANCH=${branch}
GIT_CURRENT_REPOSITORY=${repo}
GIT_CURRENT_STASHES="${repo_stashes}"
EOF

mv -v ${git_file}.new ${git_file}
