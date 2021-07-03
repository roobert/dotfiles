# change how cdr works a bit..
function c {
  if [[ $# -eq 0 ]]; then
    cdr -l
  else
    cdr $*
  fi
}

compdef c=cdr
