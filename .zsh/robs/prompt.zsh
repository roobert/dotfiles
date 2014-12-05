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
    PPROMPT="%{$FG[202]%}%#"
  ;;
  root)
    PUSER="%{$FG[161]%}%n"
    PPROMPT="%{$FG[160]%}%#"
  ;;
  *)
    PUSER="%{$FG[166]%}%n"
    PPROMPT="%{$FG[165]%}%#"
  ;;
esac

if [ "$HOST" = "disco" ]; then
  PHOST="$FG[200]%}%m"
fi

source $HOME/.zsh/zsh-git-prompt/zshrc.sh

export PS1='$PHOST $PWHERE $(git_super_status)$PPROMPT %{$FX[reset]%}'

RPS1=''
