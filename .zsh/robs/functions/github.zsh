#
# # initial setup
# git init --bare $HOME/.dotfiles
# git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME remote add origin git@github.com:roobert/dotfiles
# git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
#
# # on a new machine
# git clone git@github.com:roobert/dotfiles .dotfiles

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dfs=dotfiles
