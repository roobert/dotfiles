###
### my prompt stuff
###

# colour chart:  http://upload.wikimedia.org/wikipedia/commons/9/95/Xterm_color_chart.png or use 'spectrum_ls'

PHOST="%{$FG[104]%}%m"
#PWHERE="%{$FG[250]%}%~"
PWHERE="%{$FG[250]%}%d"
PPROMPT="%{$FG[040]%}%#"

case `whoami` in
  rw|robw)
    PUSER="%{$FG[119]%}%n"

  ;;
  robwadm)
    PUSER="%{$FG[166]%}%n"
    PPROMPT="%{$FG[202]%}%# "
  ;;
  root)
    PUSER="%{$FG[161]%}%n"
    PPROMPT="%{$FG[160]%}%# "
  ;;
  *)
    PUSER="%{$FG[166]%}%n"
    PPROMPT="%{$FG[165]%}%# "
  ;;
esac

if [ "$HOST" = "disco" ]; then
  PHOST="$FG[200]%}%m"
fi

source $HOME/.zsh/zsh-git-prompt/zshrc.sh

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{\u25cf%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{\u2716%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}%{\u271a%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{\u2193%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{\u2191%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{\u2026%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[blue]%}%{\u2714%G%}"

export PS1='$PHOST $PWHERE $(git_super_status)$PPROMPT %{$FX[reset]%}'

RPS1=''
