which pyenv > /dev/null || return
export PATH="$PYENV_ROOT/shims:$PATH"
eval "$(pyenv init --path -)"
