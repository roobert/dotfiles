# thanks mattf for implimenting stuff so i dont have to :)

# this lovely stuff means you can cd to directories that are further up the directory tree for $CWD

function up {

  if [[ $# == 0 ]]; then
    if [[ -z "${UP_PATHS}" ]]; then
      echo "no up paths, boo"
      return 1
    fi

    IFS=";"

    for up_path in $UP_PATHS; do
      echo "up_path: ${up_path}"
      up $(pwd | sed -e "s/.*${up_path}\/\([^/]*\)\/.*/\1/")
      if [[ $? == 0 ]]; then
        return 0
      fi
    done
  else
    target="$1"
  fi

  dir="$PWD"

  while [ $dir != "/" ]; do
    if [ "$dir:t" = "$target" ]; then
      builtin cd "$dir"
      return 0
    fi

    dir="$dir:h"
  done

  return 1
}

function cd {
  if ! builtin cd "$*" &>/dev/null; then
    up "$*" || builtin cd "$*"
  fi
}
