# stop here if not a shell
if [ ! -n "$PS1" ]; then return; fi

# install dotfiles if they arent installed
if [[ ! -d $HOME/.zsh/ ]]; then
  curl -sL https://github.com/roobert/dotfiles/tarball/master \
    | tar -xzv --strip-components 1 --exclude=README.md -C $HOME
fi

# source main good stuff
source $HOME/.zsh/zshrc
