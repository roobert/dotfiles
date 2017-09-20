#
# # initial setup
# git init --bare $HOME/.dotfiles
# git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
# git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME remote add origin git@github.com:roobert/dotfiles
#
# # on a new machine
# git clone git@github.com:roobert/dotfiles .dotfiles --bare
# git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
# git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dfs="dotfiles"
alias dfss="dotfiles status"
