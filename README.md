```
git clone --bare https://github.com/roobert/dotfiles $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles show HEAD:install.sh | bash
```
