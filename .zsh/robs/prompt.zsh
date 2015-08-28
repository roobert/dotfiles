###
### my prompt stuff
###

# colour chart:  http://upload.wikimedia.org/wikipedia/commons/9/95/Xterm_color_chart.png or use 'spectrum_ls'

PHOST="%{$FG[104]%}%m"
#PWHERE="%{$FG[250]%}%~"
PWHERE="%{$FG[250]%}%d"
#PPROMPT="%{$FG[040]%}%#"
PPROMPT="%{$FG[160]%}>"
VI_PROMPT="%{$FG[202]%}>"

case `whoami` in
  rw|robw)
    PUSER="%{$FG[119]%}%n"
    VI_PROMPT="%{$FG[119]%}>"

  ;;
  robwadm)
    PUSER="%{$FG[166]%}%n"
    PPROMPT="%{$FG[202]%}%# "
    VI_PROMPT="%{$FG[202]%}> "
  ;;
  root)
    PUSER="%{$FG[161]%}%n"
    PPROMPT="%{$FG[160]%}%# "
    VI_PROMPT="%{$FG[160]%}> "
  ;;
  *)
    PUSER="%{$FG[166]%}%n"
    PPROMPT="%{$FG[165]%}%# "
    VI_PROMPT="%{$FG[165]%}> "
  ;;
esac

if [ "$HOST" = "disco" ]; then
  PHOST="$FG[200]%}%m"
fi

source $HOME/.zsh/zsh-git-prompt/zshrc.sh

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[yellow]%}%{\u25cf%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{\u2716%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}%{\u271a%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{\u2193%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$FG[166]%}%{\u2191%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}%{\u2717%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}%{\u2714%G%}"

export PS1='$PHOST $PWHERE $(git_super_status)$PPROMPT %{$FX[reset]%}'
export RPS1=''

function zle-line-init zle-keymap-select {
  INSERT_MODE_PROMPT='>'
  case ${KEYMAP} in
    (vicmd)      VI_MODE="$PPROMPT" ;;
    (main|viins) VI_MODE="$VI_PROMPT" ;;
    (*)          VI_MODE="$VI_PROMPT" ;;
  esac
  export PS1='$PHOST $PWHERE $(git_super_status) ${VI_MODE} %{$FX[reset]%}'
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# prevent 2*ESC-i insert-mode switch failure
noop () { }
zle -N noop
bindkey -M vicmd '\e' noop
