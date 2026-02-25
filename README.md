```
git clone --bare https://github.com/roobert/dotfiles $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles show HEAD:._dotfiles/osx_bootstrap/install.sh | bash
```
