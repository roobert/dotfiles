```
cd $HOME
ssh-keyscan github.com
git clone --bare git@github.com:roobert/dotfiles $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
compdef dotfiles=git
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs rm -v {}
dotfiles checkout
```
