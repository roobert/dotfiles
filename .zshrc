# stop here if not a shell
if [ ! -n "$PS1" ]; then return; fi


# if not installed yet..
if [[ ! -d $HOME/.zsh/ ]]; then
  INSTALL_DOTFILES=true

# if older than 12 hours..
elif find .zsh/last_checkout -amin +720 >/dev/null 2>&1; then
  INSTALL_DOTFILES=true

# checked out but no last_checkout file..
else
  date > ~/.zsh/last_checkout

fi

if [[ $INSTALL_DOTFILES = true ]]; then

  # no --strip-components option for older versions of tar (tar (GNU tar) 1.14)
  tar --help | grep strip-components > /dev/null 2>&1
  if [[ $? == 0 ]]; then
    STRIP_CMD="--strip-components"
  else
    STRIP_CMD="--strip-path"
  fi

  echo -n "updating dotfiles: "

  # insecure option is necessary for some reason.. -m means dont care about mtime
  curl -sL --insecure https://github.com/roobert/dotfiles/tarball/master \
    | tar -xzv -m $STRIP_CMD 1 --exclude=README.md -C $HOME > /dev/null 2> .zsh/failure_log

  if [[ $? -eq 0 ]]; then
    echo 'ok!'
  else
    echo 'failures logged to .zsh/failure_log'
  fi

  chmod 700 -R $HOME/.ssh

  date > $HOME/.zsh/last_checkout
fi

# source main good stuff
source $HOME/.zsh/zshrc
