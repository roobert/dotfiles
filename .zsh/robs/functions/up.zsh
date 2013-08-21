# thanks mattf for implimenting stuff so i dont have to :)

function up {

    dir=$PWD;

    while [ $dir != "/" ]; do
        if [ $dir:t = $1 ]; then
            builtin cd $dir 2> /dev/null
            return 0
        fi
        dir=$dir:h
    done
    return 1
}

if ! builtin cd $* &>/dev/null; then
  up $* || builtin cd $*
fi

