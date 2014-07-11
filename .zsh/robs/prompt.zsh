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

if [ -z "$DEBIAN_CHROOT"  ] && [ -r /etc/debian_chroot  ]; then
  DEBIAN_CHROOT="%{$FG[135]%}$(cat /etc/debian_chroot)%{$FX[reset]%}:"
fi

if [ "$HOST" = "disco" ]; then
  PHOST="$FG[200]%}%m"
fi

#export PS1="$PUSER $PHOST $PWHERE $PPROMPT %{$FX[reset]%}"
export PS1="$DEBIAN_CHROOT$PHOST $PWHERE $PPROMPT %{$FX[reset]%}"

RPS1=''
