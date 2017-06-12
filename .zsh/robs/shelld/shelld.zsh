if [[ ! -f ~/.shelld/pid.lock  ]]; then
  nohup ~/.zsh/robs/shelld/daemon.sh & 2> /dev/null 2>&1
  echo $! > ~/.shelld/pid.lock
  disown
fi
