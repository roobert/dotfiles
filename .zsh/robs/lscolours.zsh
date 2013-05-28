# Prettier directory colours
# https://github.com/trapd00r/LS_COLORS
# on os X install coreutils from brew and add gnubin to front of PATH 
if type dircolors 2>&1 > /dev/null; then
  eval $(dircolors -b $HOME/.zsh/lscoloursrc)
fi

export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}


