```
# install!
mkdir ~/.dotfiles && \
  curl -sL https://github.com/roobert/dotfiles/tarball/master \
    | tar -xzv --strip-components 1 --exclude=README.md -C $HOME/.dotfiles \
  && $HOME/.dotfiles/bootstrap.sh
```
