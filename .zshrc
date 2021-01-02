export TERM=screen-256color

# stop here if not a shell
if [ ! -n "$PS1" ]; then return; fi

source $HOME/.zsh/zshrc

if [ -r $HOME/.zsh/local ]; then
  source $HOME/.zsh/local
fi
