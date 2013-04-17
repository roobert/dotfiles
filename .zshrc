#
# some nice things to remember..
#
# =foo expands to $PATH/foo
#
# !(^|$|:#) expands to arguments of previous command
#
# filename(<tab> expands 
#
# zmv '(*).mp3' '$1.wma'
#
# zcalc
#
#

# stop here if not a shell
if [ ! -n "$PS1" ]; then return; fi

# stuff i like from oh-my-zsh: lib/grep.zsh lib/spectrum.zsh lib/completion.zsh? plugins/vi-mode plugins/git plugins/nyan
# this stuff has now been merged into zshrc.. keep list here for future reference

# checkout .oh-my-zsh if it doesn't exist
#if [ ! -d "$HOME/.oh-my-zsh" ]; then
#
#  # check for git
#  which git 2>&1 > /dev/null
#
#  if [ $? -eq 0 ]; then
#    git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
#  else
#    echo ".oh-my-zsh does not exist but cannot checkout since 'git' is not available"
#  fi
#fi

# initialize oh-my-zsh
#ZSH=$HOME/.oh-my-zsh
#plugins=(git vi-mode nyan)
#source $ZSH/oh-my-zsh.sh
#ZSH_THEME="rob"

# remove .oh-my-zsh if exists
[[ -d "$HOME/.oh-my-zsh" ]] && rm -rfv $HOME/.oh-my-zsh

###
### .oh-my-zsh/lib/spectrum.zsh
###

# A script to make using 256 colors in zsh less painful.
# P.C. Shyamshankar <sykora@lucentbeing.com>
# Copied from http://github.com/sykora/etc/blob/master/zsh/functions/spectrum/
typeset -Ag FX FG BG

FX=(
  reset     "%{[00m%}"
  bold      "%{[01m%}" no-bold      "%{[22m%}"
  italic    "%{[03m%}" no-italic    "%{[23m%}"
  underline "%{[04m%}" no-underline "%{[24m%}"
  blink     "%{[05m%}" no-blink     "%{[25m%}"
  reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

for color in {000..255}; do
  FG[$color]="%{[38;5;${color}m%}"
  BG[$color]="%{[48;5;${color}m%}"
done

# Show all 256 colors with color number
function spectrum_ls {
  for code in {000..255}; do
  print -P -- "$code: %F{$code}Test%f"
  done
}

#changing mode clobbers the keybinds, so store the keybinds before and execute 
#them after
binds=`bindkey -L`
bindkey -v
for bind in ${(@f)binds}; do eval $bind; done
unset binds

# taken from plugins/nyan 
if [[ -x `which nc` ]]; then
  alias nyan='nc -v miku.acm.uiuc.edu 23' # nyan cat
fi

###
### .oh-my-zsh/lib/completion.zsh
###

unsetopt menu_complete  # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu        # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end
setopt sh_word_split    # don't retokenize variables on expansion WARNING: could this mess things up? is this the default for posix sh?

WORDCHARS=''

zmodload -i zsh/complist

## case-insensitive (all),partial-word and then substring completion
if [ "x$CASE_SENSITIVE" = "xtrue" ]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unset CASE_SENSITIVE
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi

zstyle ':completion:*' list-colors ''

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

# use /etc/hosts and known_hosts for hostname completion
[ -r /etc/ssh/ssh_known_hosts ] && _global_ssh_hosts=(${${${${(f)"$(</etc/ssh/ssh_known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_global_ssh_hosts[@]"
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  "$HOST"
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH/cache/

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

# ... unless we really want to.
zstyle '*' single-ignored show

if [ "x$COMPLETION_WAITING_DOTS" = "xtrue" ]; then
  expand-or-complete-with-dots() {
    echo -n "\e[31m......\e[0m"
    zle expand-or-complete
    zle redisplay
  }
  zle -N expand-or-complete-with-dots
  bindkey "^I" expand-or-complete-with-dots
fi

###
### my prompt stuff
###

# colour chart:  http://upload.wikimedia.org/wikipedia/commons/9/95/Xterm_color_chart.png or use 'spectrum_ls'

PHOST="%{$FG[104]%}%m"
PWHERE="%{$FG[250]%}%~"
PPROMPT="%{$FG[040]%}%#"

case `whoami` in
  rw|robw)
    PUSER="%{$FG[119]%}%n"

  ;;
  robwadm)
    PUSER="%{$FG[166]%}%n"
    PPROMPT="%{$FG[202]%}%#"
  ;;
  root)
    PUSER="%{$FG[161]%}%n"
    PPROMPT="%{$FG[160]%}%#"
  ;;
  *)
    PUSER="%{$FG[166]%}%n"
    PPROMPT="%{$FG[165]%}%#"
  ;;
esac

if [ "$HOST" = "disco" ]; then
  PHOST="$FG[200]%}%m"
fi

export PS1="$PUSER $PHOST $PWHERE $PPROMPT %{$FX[reset]%}"

###
### my settings, aliases and functions
###

if [ -d "$HOME/work/systems/pm" ]; then
  export CDPATH=".:$HOME/work/systems/pm/:$HOME/work/systems/trunk"
fi

# if you've installed brew using coreutils on osx then prefer gnu 'ls' etc over osx bsd utils
if [ -d "/usr/local/opt/coreutils/libexec/gnubin" ]; then
  PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi

# terminal settings
case $TERM in
  rxvt|*term)
    precmd() {
      print -Pn "\e]0;%m:%~\a"
    }
    preexec() {
      print -Pn "\e]0;$1\a"
    }

    TERM="xterm-256color"
  ;;
esac

# include my paths in path
MY_PATHS=($HOME/bin /opt/semantico/bin)

for my_path in $MY_PATHS; do
  if [ -d "$my_path" ]; then
    export PATH="$PATH:$my_path"
  fi
done

# aliases
alias vi="vim"
alias vim="vim -T xterm-256color"
alias screen="TERM=xterm screen"
alias ls="ls --color=yes"
alias ssh="ssh -t" # force-allocate pseudo-tty
alias haste_work="HASTE_SERVER=http://pasti.co haste"
alias m="mount | column -t"
alias gup='git commit -am "updated" && git push'
alias pa="puppet agent --onetime --no-daemonize -v"
alias pt="puppet_alltags -f"
alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gd="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -p"
alias am="alsamixer"
alias empty_trash="rm -rf ~/.local/share/Trash"
alias rubygems_login="curl -u roobert https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials"

# connect to os X and login to vagrant instances
alias vpm="ssh rpro -t 'cd vagrant-puppetmaster; vagrant ssh'"
alias vpa="ssh rpro -t 'cd vagrant-puppet-client; vagrant ssh'"

# stuff in ~/bin
alias f="r_find"
alias fw="r_find_wild"
alias hl="r_highlight"
alias highlight="r_highlight"

# ps stuff
export PS_FORMAT="user,pid,args"
alias ps='ps w'                   # ps - always assume unlimited width
alias p='ps axcwf'                # p  - display all, 
alias pu='ps -o user,pid,command' # pu

# puppet
alias pa="puppet agent --onetime --no-daemonize -v| sed -e 's/\(notice.*$\)/\1\n/'"
alias puppet_alltags="puppet_alltags -f| sed -e 's/\(notice.*$\)/\1\n/'"
alias puppet_noop="puppet_noop | sed -e 's/\(notice.*$\)/\1\n/'"
alias pa="puppet_alltags"
alias pn="puppet_noop"

# reload zshrc
alias rzsh="exec zsh -l"
alias rz="rzsh"
alias zr="rz"

# configure some stuff
export LESS="-R" # allow escape sequences to be interpreted properly
export EDITOR="vim"
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

# subversion
alias si='svn ci -m'

# Prettier directory colours
# https://github.com/trapd00r/LS_COLORS
# on os X install coreutils from brew and add gnubin to front of PATH 
if type dircolors 2>&1 > /dev/null; then
  eval $(dircolors -b $HOME/.lscolorsrc)
fi

export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# history settings
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
unsetopt correct_all
unsetopt share_history
setopt inc_append_history
setopt extended_history
setopt hist_no_store
setopt hist_save_no_dups
HISTFILE=$HOME/.zsh_history
HISTSIZE=9999
SAVEHIST=9999

# all taken from: https://github.com/tureba/myconfigfiles/blob/master/zshrc
# this fixes switching between vi-modes
bindkey -rpM viins '^['

bindkey -M vicmd k vi-up-line-or-history
bindkey -M vicmd j vi-down-line-or-history

bindkey -v
# fix backwards history search
bindkey -M viins "^r" history-incremental-search-backward
bindkey -M vicmd "^r" history-incremental-search-backward
# fix backspace key
bindkey -M viins "^H" backward-delete-char
bindkey -M vicmd "^H" backward-delete-char
bindkey -M viins "^?" backward-delete-char
bindkey -M vicmd "^?" backward-delete-char
# fix insert key
bindkey -M viins "^[[2~" overwrite-mode
bindkey -M vicmd "^[[2~" overwrite-mode
# fix delete key
bindkey -M viins "^[[3~" delete-char
bindkey -M vicmd "^[[3~" delete-char
# fix arrow keys
bindkey -M viins "^[[A" up-line-or-history
bindkey -M vicmd "^[[A" up-line-or-history
bindkey -M viins "^[[B" down-line-or-history
bindkey -M vicmd "^[[B" down-line-or-history
bindkey -M viins "^[[C" forward-char
bindkey -M vicmd "^[[C" forward-char
bindkey -M viins "^[[D" backward-char
bindkey -M vicmd "^[[D" backward-char
# line movements in commnad mode (needs home and end)
bindkey -M vicmd "0" beginning-of-line
bindkey -M vicmd "$" end-of-line
# line movements in insert mode
bindkey -M viins "^[[7~" beginning-of-line # home
bindkey -M viins "^[[8~" end-of-line # end

# enable advanced globbing
setopt extended_glob

# useful function to update zshrc for adm user
# FIXME: simplify by doing: cd to trunk/, gh_fetch, sf . both -f, svn-addall; svn commit
function update_dotfiles_adm_user {

  BRANCHES=(trunk branches/testing branches/production)
  DOTFILES=(
    .bash_profile
    .bashrc
    .inputrc
    .lscolorsrc
    .vimrc
    .zshrc
    .vim/colors/xterm16.vim
    .vim/colors/jellybeans.vim
    .vim/colors/solarized.vim
    .vim/ftdetect/puppet.vim
    .vim/syntax/puppet.vim
    .vim/after/plugin/TabularMaps.vim
    .vim/autoload/tabular.vim
    .vim/plugin/Tabular.vim
  )

  # copy dotfiles to adm env/ directory
  for dotfile in $DOTFILES; do
    for branch in $BRANCHES; do
      DOTFILE_PATH="$HOME/work/systems/pm/fileserver/$branch/dist/user/robwadm/env/`dirname $dotfile`"

      [[ ! -d "$DOTFILE_PATH" ]] && mkdir -p $DOTFILE_PATH
      #[[ ! -f $dotfile ]] && ( echo "dotfile does not exist: $dotfile" && exit 1 )

      cp -v $HOME/$dotfile $DOTFILE_PATH
    done
  done

  UPDATED_DOTFILES=""
  NEW_DOTFILES=""

  # commit files (one commit per file is inefficient but whatever..)
  for branch in $BRANCHES; do
    OLD_IFS="$IFS"
    IFS=$'\n'

    for svn_entry in `svn status $HOME/work/systems/pm/fileserver/$branch/dist/user/robwadm/env/`; do

      dotfile_status=`echo "$svn_entry" | awk '{ print $1 }'`

      dotfile=`echo "$svn_entry" | awk '{ print $2 }'`

      if [[ "$dotfile_status" = "?" ]]; then
        NEW_DOTFILES=($dotfile $NEW_DOTFILES)

      elif [[ "$dotfile_status" = "M" ]]; then
        UPDATED_DOTFILES=($dotfile $UPDATED_DOTFILES)

      else
        echo "file '$dotfile' has unknown status: $dotfile_status"
        return 1
      fi
    done
  done

  # add any new files/dirs to svn
  if [ ! -z "$NEW_DOTFILES" ]; then
    echo "# new dotfiles: $NEW_DOTFILES"
    for dotfile in $NEW_DOTFILES; svn add $dotfile
  fi

  # commit any changed dotfiles
  if [ ! -z "$UPDATED_DOTFILES" ] || [ ! -z "$NEW_DOTFILES" ]; then
    svn status $UPDATED_DOTFILES
    svn ci -m '# updated robwadm dotfiles..' $UPDATED_DOTFILES
  fi
}

# Examples:
#
#   gh_fetch <repo> <path>
#
function gh_fetch {

  REPOS="$1"
  TARGET="$2"

  if [[ $# -eq 0 ]]; then
    echo "$0 <repo> <path>"
    return 1
  fi

  if [[ $# > 2 ]]; then
    echo "too many arguments!"
    return 1
  fi

  if [[ $TARGET = "" ]]; then
    TARGET="."
  else
    [[ ! -d $TARGET ]] && ( mkdir -p $TARGET || ( echo "target directory does not exist and could not be created: $TARGET" && return 1 ))
  fi

  # FIXME: check to see if repo exists..

  curl -sL https://github.com/roobert/$REPOS/tarball/master \
  | tar -xzv --strip-components 1 --exclude=README.md -C $TARGET
}

alias gh_install="gh_fetch"

# Examples:
#
#   gh_pull <repo>
#
function gh_pull {
  REPOS="$1"
  TMP_DIR="$HOME/tmp"

  # either clone or update repo depending on whether it's already checked out
  if [[ -d $TMP_DIR/$REPOS ]]; then
    ( cd $TMP_DIR/$REPOS && git pull )
  else
    git clone ssh://git@github.com/roobert/$REPOS $TMP_DIR/$REPOS
  fi
}

# Examples:
#
#  gh_push <repo> -f
#
function gh_push {

  # avant-garde indenting
     REPOS="$1"
     FORCE="$2"
   TMP_DIR="$HOME/tmp"
  WORK_DIR="$TMP_DIR/$REPOS"

  if [[ $# -eq 0 ]]; then
    echo "$0 <repository>"
    return 1
  fi

  # determine where to copy files from
  SOURCE_DIR="`pwd`/"

  # checkout or update repository
  gh_pull $REPOS

  # FIXME: files with spaces in get broken up..
  DOTFILES=( $WORK_DIR/.*/**/*~$WORK_DIR/.git/* $WORK_DIR/.*~$WORK_DIR/.git )

  # for each file that has been checked out, copy over it with file from $SOURCE_DIR
  for old_file in $DOTFILES; do

    # skip directories
    if [[ -d $old_file ]]; then
      continue
    fi

    new_file=`echo "$old_file" | sed "s|$WORK_DIR/|$SOURCE_DIR|"`

    if [[ ! -f $new_file ]]; then
      echo "# file does not exist: $new_file (skipping)"
      continue
    fi

    # FIXME: it's ineffecient to diff twice..
    diff "$old_file" "$new_file" > /dev/null 2>&1

    # only copy changed files..
    if [[ $? -ne 0 ]]; then
      echo "# < \"$old_file\""
      echo "# > \"$new_file\""

      # display a diff of changed files (repeat of previous diff)
      if type colordiff > /dev/null 2>&1; then
        colordiff "$old_file" "$new_file" # mmm sexy!
      else
        diff "$old_file" "$new_file"
      fi

      if [[ "$FORCE" = "-f" ]]; then
        cp -vr "$new_file" "$old_file"
      else
        echo
        echo "# not pushing changes as -f wasn't specified"
        echo
      fi
    fi
  done

  if [[ "$FORCE" = "-f" ]]; then
    # commit and push
    ( cd $WORK_DIR && git commit -am 'updated' && git push )
  fi
}

#
# functions to install some useful tools..
#

# list useful stuff like aliases and functions..
function help {
  echo "# functions"
  grep '^function' ~/.zshrc | awk '{ print $2 }'

  echo "# aliases"
  alias
}

function install_common_tools {
  sudo apt-get install git subversion vim zsh tree colordiff ncdu htop ack-grep apt-file
}

function install_ruby_tools {
  sudo apt-get install rbenv ruby-build
  gem install awesome_print net-http-spy wirble bond boson looksee
}

function install_common_tools_osx {
  ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
  brew install zsh coreutils wget
}

function g {
   egrep --exclude-dir=\.svn $* | grep -v grep
}

# ask kill
function ak {
  PS_LIST=`ps ax|grep $1`
  echo $PS_LIST
}

# NOTE: moved this to the bottom since it may break other stuff.. (ordering matters!)

###
### .oh-my-zsh/plugins/vi-mode
###

function zle-line-init zle-keymap-select {
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

###
### bookmark stuff
###

BOOKMARKS="$HOME/.bookmarks-zsh"

function bookmarks {

  if [[ $# -eq 0 ]]; then

    # list bookmarks
    echo "# bookmarks"
    bookmarks reload
    hash -d | column -t -s '='

    return
  fi

  if [[ $1 = 'reload' ]]; then
    hash -d -r && touch $BOOKMARKS && source $BOOKMARKS

    return
  fi

#  if [[ $1 = 'rm' ]]; then
#
#    echo "# attempting to remove directory from bookmarks: `pwd`"
#    sed -i "/.*\"`pwd`\"/d" ~/.zshmarks
#
#    bookmarks reload
#
#    return
#  fi

  if [[ $1 = '.' ]]; then
    # set bookmark name to be current dir name
    name="`basename $(pwd)`"
  else
    # set bookmark name manually
    name="$1"
  fi

  echo "# adding bookmark '$name': `pwd`"
  echo "hash -d $name=\"`pwd`\"" >> $BOOKMARKS && bookmarks reload
}

alias b="bookmarks"
alias br="bookmarks reload"

bookmarks reload

###
### misc.
###

# list files as well as dirs when cd tab completing
autoload -U is-at-least
if is-at-least 5.0.0; then
  compdef _path_files cd
fi

# initialize rbenv
if [[ -d "$HOME/.rbenv/bin" ]]; then
  PATH="$HOME/.rbenv/bin:$PATH"
fi

type rbenv > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
  eval "$(rbenv init -)"
fi

# check if my bin/ is checked out
if [[ ! -x "$HOME/bin/r_find" ]]; then
  echo "# attempting to install bin files using subshell for: gh_fetch bin bin"
  timeout 5 gh_fetch bin bin
  #( gh_fetch bin bin ) & sleep 5; kill $!
fi

###
### semantico svn stuff
###

export SEMANTICO_SVN_SERVER="https://svn.semantico.net/repos/"

function svn.sem {
  if [[ $# -ne '2' ]]; then
    echo "$0 <command> <repos>"
    die  "e.g: $0 checkout systems"
  fi

  svn $1 $SEMANTICO_SVN_SERVER/$2
}

# load ssh keys
ssh-add -l|grep 'no identities' > /dev/null 2>&1

if [[ $? = 0 ]]; then
  for id in `find $HOME/.ssh/ -name "id_rsa*" | grep -v 'id_rsa.pub'`; ssh-add $id
  ssh-add -l
fi
