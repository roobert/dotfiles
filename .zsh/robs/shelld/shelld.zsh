
#if [[ -z $SSH_TTY ]]; then
#  if [[ ! -f ~/.shelld/pid.lock ]]; then
#    nohup ~/.zsh/robs/shelld/daemon.sh &
#    echo $! > ~/.shelld/pid.lock
#    disown
#  fi
#fi
