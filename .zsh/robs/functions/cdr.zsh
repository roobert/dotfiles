# change how cdr works a bit..

autoload -U is-at-least

if is-at-least 4.4.0; then

  function c {
    if [[ $# -eq 0 ]]; then
      cdr -l
    else
      cdr $*
    fi
  }

  compdef c=cdr
fi
