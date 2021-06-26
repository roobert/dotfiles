#system tools
alias ls="ls --group-directories-first --color=auto"
alias screen="TERM=xterm screen"
alias ssh="ssh -t"

alias empty_trash="rm -rf ~/.local/share/Trash"

# vim
#alias vim="vim -T xterm-256color -p"
alias vim="nvim -p"
alias vi="nvim -p"

function gcm () {
  git commit -m "$*"  
}

# git
alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gdl="gl -p"
alias gdt="git diff-tree --no-commit-id --name-only -r HEAD"
alias gs='git status --short --branch'
alias gpo='git push origin HEAD'
alias gp='git pull'
alias gdh='git diff HEAD'
alias gdc='git diff --cached'
alias gb='git checkout -b'
alias gc='git checkout'
alias gd='git diff'
alias ga='git add'
alias gaa='git add .'
alias grh='git reset HEAD'
alias gm='git checkout master'

# linux ps stuff
#export PS_FORMAT="user,pid,etime,args"
#alias ps='ps ww'                     # ps - always assume unlimited width
#alias pa='ps axcwwf'                  # p  - display all
#alias pu='ps -o user,pid,etime,command ww' # pu
#alias p='ps f -o cmd'
alias p="ps ww -u"
alias pu="ps ww -u"
alias px="ps ww -axu"
alias pa="ps ww -axu"

# reload zshrc
alias rzsh="exec zsh -l"
alias rz="rzsh"
alias zr="rz"

# configure some stuff
export LESS="-R" # allow escape sequences to be interpreted properly
export EDITOR="nvim"
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

# global aliases mean you can do: foo DN and it'll expand to 'foo >/dev/null 2>&1'
alias -g DN='>/dev/null 2>&1'

# woo! echo 'foo bar baz' | COL2
alias -g COL1="awk '{ print \$1 }'"
alias -g COL2="awk '{ print \$2 }'"
alias -g COL3="awk '{ print \$3 }'"
alias -g COL4="awk '{ print \$4 }'"
alias -g COL5="awk '{ print \$5 }'"
alias -g COL6="awk '{ print \$6 }'"
alias -g COL7="awk '{ print \$7 }'"
alias -g COL8="awk '{ print \$8 }'"
alias -g COL9="awk '{ print \$9 }'"
