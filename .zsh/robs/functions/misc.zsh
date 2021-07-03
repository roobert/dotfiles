#
# shortcuts to install some useful tools..
#

function wrap-cli-input () {
  BUFFER="\$($BUFFER)"
}

zle -N wrap-cli-input
bindkey -M viins '^g' wrap-cli-input

function prepend-cli-input-vim () {
  BUFFER="vim $BUFFER"
}

zle -N prepend-cli-input-vim
bindkey -M viins '^e' prepend-cli-input-vim

function keygen {
  NAME=$1
  if [[ -z $NAME ]]; then
    echo "specify key name!"
    return 1
  fi
  ssh-keygen -t rsa -b 4096 -C "id_rsa-$NAME" -f ~/.ssh/id_rsa-$NAME -q -N ""
}

# grep edit - edit files which match some grep pattern
function gred {
  vi $(grep $* | cut -d: -f1 | sort | uniq)
}
