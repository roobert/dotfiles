```
cd $HOME
ssh-keyscan github.com
git clone --bare git@github.com:roobert/dotfiles $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout
```
