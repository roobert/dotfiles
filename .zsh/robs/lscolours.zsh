# Prettier directory colours
# https://github.com/trapd00r/LS_COLORS
# on os X install coreutils from brew and add gnubin to front of PATH

if type dircolors 2>&1 > /dev/null; then
  eval $(dircolors -b $HOME/.zsh/lscoloursrc)
else
  if [[ -x /usr/local/opt/coreutils/libexec/gnubin/dircolors ]]; then
    if ! echo $PATH | grep "coreutils" 2> /dev/null; then
      export PATH="/usr/local/opt/coreutils/libexec/gnubin/:$PATH"
    fi

    eval $(dircolors -b $HOME/.zsh/lscoloursrc)
  fi
fi

export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
