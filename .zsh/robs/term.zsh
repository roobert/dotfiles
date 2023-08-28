# terminal settings
case $TERM in
  *rxvt*|*term)
    precmd() {
      print -Pn "\e]0;%m:%~\a"
    }
    preexec() {
      print -Pn "\e]0;$1\a"
    }
  ;;
esac
