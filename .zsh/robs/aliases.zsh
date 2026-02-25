# system tools
if test -x /opt/homebrew/bin/gls; then
  alias ls="gls --group-directories-first --color=auto"
else
  alias ls="ls --color=auto"
fi

alias screen="TERM=xterm screen"
alias ssh="TERM=xterm-256color ssh -t"

alias empty_trash="rm -rf ~/.local/share/Trash"

# vim
alias vim="nvim --"
alias vi="nvim --"

# git
alias clone="gh repo clone"
alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gdl="gl -p"
alias gdt="git diff-tree --no-commit-id --name-only -r HEAD"
alias gs='git status --short --branch'
alias gpo='git push origin HEAD'
alias gp='git pull'
alias gdh='git diff HEAD'
alias gdc='git diff --cached'
alias gb='git checkout -b'
alias gd='git diff'
alias ga='git add'
alias gaa='git add .'
alias grh='git reset HEAD'
alias gm='git checkout master'

function gcommit() {
  git commit -m "$*"
}

function gfix() {
  local first_arg=$1
  shift
  if [[ $first_arg == *"/"* || $first_arg == *"."* ]]; then
    # If the first argument contains a slash or dot, assume it's not a scope
    git commit -m "fix: $first_arg $*"
  else
    git commit -m "fix($first_arg): $*"
  fi
}

function gfeat() {
  local first_arg=$1
  shift
  if [[ $first_arg == *"/"* || $first_arg == *"."* ]]; then
    # If the first argument contains a slash or dot, assume it's not a scope
    git commit -m "feat: $first_arg $*"
  else
    git commit -m "feat($first_arg): $*"
  fi
}

function gdoc() {
  local first_arg=$1
  shift
  if [[ $first_arg == *"/"* || $first_arg == *"."* ]]; then
    # If the first argument contains a slash or dot, assume it's not a scope
    git commit -m "doc: $first_arg $*"
  else
    git commit -m "doc($first_arg): $*"
  fi
}

# linux ps stuff
alias p="ps ww -u"
alias pu="ps ww -u"
alias px="ps ww -axu"
alias pa="ps ww -axu"

# reload zshrc
alias rzsh="exec zsh -l"

# configure some stuff
export LESS="-R" # allow escape sequences to be interpreted properly
export EDITOR="vim"

alias grep='grep --color=auto'
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

alias visox="vi ~/._dotfiles/osx.md"

alias kdebug="kubectl run --rm -it --image ubuntu kdebug /bin/sh"

alias tclaude="cd tmp; claude"
#alias claude='~/bin/claude-sandbox.sh'
