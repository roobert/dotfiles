# stop here if not a shell
if [ ! -n "$PS1" ]; then return; fi

# if older than 12 hours..
if test `find .zsh/last_checkout -amin +720`; then
  INSTALL_DOTFILES=true
fi

# if not installed yet..
if [[ ! -d $HOME/.zsh/ ]]; then
  INSTALL_DOTFILES=true
fi

if [[ $INSTALL_DOTFILES = true ]]; then

  # no --strip-components option for older versions of tar (tar (GNU tar) 1.14)
  tar --help | grep strip-components > /dev/null 2>&1
  if [[ $? == 0 ]]; then
    STRIP_CMD="--strip-components"
  else
    STRIP_CMD="--strip-path"
  fi

  # insecure option is necessary for some reason.. -m means dont care about mtime
  curl -sL --insecure https://github.com/roobert/dotfiles/tarball/master \
    | tar -xzv -m $STRIP_CMD 1 --exclude=README.md -C $HOME

  chmod 700 -R $HOME/.ssh

  date > $HOME/.zsh/last_checkout
fi

# source main good stuff
source $HOME/.zsh/zshrc
