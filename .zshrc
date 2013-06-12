# stop here if not a shell
if [ ! -n "$PS1" ]; then return; fi

# install dotfiles if they arent installed
if [[ ! -d $HOME/.zsh/ ]]; then
  # no --strip-components option for older versions of tar (tar (GNU tar) 1.14)
  tar --help | grep strip-components > /dev/null 2>&1
  if [[ $? == 0 ]]; then
    STRIP_CMD="--strip-components"
  else
    STRIP_CMD="--strip-path"
  fi

  # insecure option is necessary for some reason.. -m means dont care about mtime
  curl -sL --insecure https://github.com/roobert/dotfiles/tarball/master \
  | tar -xzv -m $STRIP_CMD 1 --exclude=README.md -C $TARGET
fi

# source main good stuff
source $HOME/.zsh/zshrc
