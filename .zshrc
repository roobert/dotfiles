# stop here if not a shell
if [ ! -n "$PS1" ]; then return; fi

# run `zprof` to see results of zsh profiling
#zmodload zsh/zprof

source $HOME/.zsh/zshrc

if [ -r $HOME/.zsh/local ]; then
  source $HOME/.zsh/local
fi
