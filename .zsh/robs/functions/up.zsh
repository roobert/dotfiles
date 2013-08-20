# thanks mattf for implimenting stuff so i dont have to :)

function up {

    dir=$PWD;

    while [ $dir != "/" ]; do
        if [ $dir:t = $1 ]; then
            cd $dir
            return 0
        fi
        dir=$dir:h
    done
    return 1
}

function cd {
  builtin cd $* &>/dev/null || up $*
}
