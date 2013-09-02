# thanks mattf for implimenting stuff so i dont have to :)

# this lovely stuff means you can cd to directories that are further up the directory tree for $CWD

function up {

  dir=$PWD;

  while [ $dir != "/" ]; do
    if [ $dir:t = $1 ]; then
      builtin cd $dir
      return 0
    fi

    dir=$dir:h
  done

  return 1
}

function cd {
    if ! builtin cd $* &>/dev/null; then
        up $* || builtin cd $*
    fi
}
