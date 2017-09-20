which kubectl > /dev/null 2>&1 && source <(kubectl completion zsh | sed -e '/flaghash.*true/s/# pad/2>\/dev\/null # pad/')
