# super awesome cdr! - http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Recent-Directories
# list files as well as dirs when cd tab completing
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# change how cdr works a bit..
function c {
  if [[ $# -eq 0 ]]; then
    cdr -l
  else
    cdr $*
  fi
}

compdef c=cdr
