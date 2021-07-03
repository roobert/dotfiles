BOOKMARKS="$HOME/.bookmarks-zsh"

function bookmarks {

  if [[ $# -eq 0 ]]; then

    # list bookmarks
    echo "# bookmarks"
    bookmarks reload
    hash -d | column -t -s '='

    return
  fi

  if [[ $1 = 'reload' ]]; then
    hash -d -r && touch $BOOKMARKS && source $BOOKMARKS

    return
  fi

  if [[ $1 = '.' ]]; then
    # set bookmark name to be current dir name
    name="`basename $(pwd)`"
  else
    # set bookmark name manually
    name="$1"
  fi

  echo "# adding bookmark '$name': `pwd`"
  echo "hash -d $name=\"`pwd`\"" >> $BOOKMARKS && bookmarks reload
}

alias b="bookmarks"
alias br="bookmarks reload"
