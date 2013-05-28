# stop here if not a shell
if [ ! -n "$PS1" ]; then return; fi

# install dotfiles if they arent installed
[[ ! -d $HOME/.dotfiles ]]; then
  mkdir $HOME/.dotfiles

  curl -sL https://github.com/roobert/dotfiles/tarball/master \
    | tar -xzv --strip-components 1 --exclude=README.md -C $HOME/.dotfiles

  $HOME/.dotfiles/bootstrap.zsh
fi

# source main good stuff
source $HOME/.zsh/zshrc
