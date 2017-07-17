test -f $HOME/opt/google-cloud-sdk/completion.zsh.inc && source $HOME/opt/google-cloud-sdk/completion.zsh.inc
test -f $HOME/opt/google-cloud-sdk/path.zsh.inc && source $HOME/opt/google-cloud-sdk/path.zsh.inc
if which kubectl > /dev/null 2>&1; then
  source <(kubectl completion zsh | sed -e '/flaghash.*true/s/# pad/2>\/dev\/null # pad/')
fi
