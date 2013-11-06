#
# TODO
# * trap ^C?
# * ping test or fail?
#

# stop here if not a shell
if [ ! -n "$PS1" ]; then return; fi

if [[ ! -f "$HOME/.dotfiles-last_checkout" ]]; then
  #echo ".dotfiles-last_checkout doesn't exist.."
  export INSTALL_DOTFILES="true"

elif [[ "$(find $HOME/.dotfiles-last_checkout -cmin +720 2>/dev/null|wc -l)" -gt 0 ]]; then
  #echo "dotfiles older than 12hrs old.."
  export INSTALL_DOTFILES="true"

else
  # dotfiles already installed..
  INSTALL_DOTFILES="false"
fi

if [[ -f "$HOME/.dotfiles-no_checkout" ]]; then
  #echo "no dotfiles checkout due to file: $HOME/.dotfiles-no_checkout"
  INSTALL_DOTFILES="false"
fi

if $($INSTALL_DOTFILES); then

  # no --strip-components option for older versions of tar (tar (GNU tar) 1.14)
  tar --help | grep strip-components > /dev/null 2>&1

  if [[ $? == 0 ]]; then
    STRIP_CMD="--strip-components"
  else
    STRIP_CMD="--strip-path"
  fi

  #echo -n "updating dotfiles: "

  # insecure option is necessary for some reason.. -m means dont care about mtime
  curl -sL --insecure https://github.com/roobert/dotfiles/tarball/master \
    | tar -xzv -m $STRIP_CMD 1 --exclude=README.md -C $HOME > /dev/null 2> .dotfiles-failure_log

  if [[ $? -eq 0 ]]; then
    #echo 'ok!'
    true
  else
    echo 'failures logged to .dotfiles-failure_log'
  fi

  chmod 700 -R $HOME/.ssh

  date > $HOME/.dotfiles-last_checkout
fi

# source main good stuff
source $HOME/.zsh/zshrc
