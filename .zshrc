# stop here if not a shell
if [ ! -n "$PS1" ]; then return; fi

# stuff i like from oh-my-zsh: lib/grep.zsh lib/spectrum.zsh lib/completion.zsh? plugins/vi-mode plugins/git plugins/nyan
# this stuff has now been merged into zshrc.. keep list here for future reference

# checkout .oh-my-zsh if it doesn't exist
#if [ ! -d "$HOME/.oh-my-zsh" ]; then
#
#    # check for git
#    which git 2>&1 > /dev/null
#
#    if [ $? -eq 0 ]; then
#        git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
#    else
#        echo ".oh-my-zsh does not exist but cannot checkout since 'git' is not available"
#    fi
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
function spectrum_ls() {
  for code in {000..255}; do
    print -P -- "$code: %F{$code}Test%f"
  done
}

###
### .oh-my-zsh/plugins/vi-mode
###

function zle-line-init zle-keymap-select {
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

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

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

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

# xterm titlebars
case $TERM in
    xterm*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}"; echo -ne "\007"'
    ;;
    screen)
        PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}"; echo -ne "\033\\"'
    ;;
esac

# set term
if [ "$TERM" = "xterm" ] || [ "$TERM" = "mlterm" ] || [ "$TERM" = "rxvt-unicode-256color" ]; then
  TERM="xterm-256color"
fi

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
alias grep="egrep --exclude-dir=\.svn -n"
alias haste="HASTE_SERVER=http://pasti.co haste"
alias m="mount | column -t"

# stuff in ~/bin
alias f="r_find"
alias fw="r_find_wild"
alias hl="r_highlight"
alias highlight="r_highlight"

# configure some stuff
export PSARGS="-ax"
export LESS="-R" # allow escape sequences to be interpreted properly
export EDITOR="vim"
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
export SEMANTICO_SVN_SERVER="https://svn.semantico.net/repos/"
alias svn.sem="svn $1 $SEMANTICO_SVN_SERVER/$2"

# Prettier directory colours
# https://github.com/trapd00r/LS_COLORS
# on os X install coreutils from brew and add gnubin to front of PATH 
if type dircolors 2>&1 > /dev/null; then
    eval $(dircolors -b $HOME/.lscolorsrc)
fi

export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# history settings
unsetopt correct_all
unsetopt share_history
setopt inc_append_history
setopt extended_history
setopt hist_no_store
setopt hist_save_no_dups
HISTFILE=$HOME/.zsh_history
HISTSIZE=9999
SAVEHIST=9999

bindkey -M vicmd k vi-up-line-or-history
bindkey -M vicmd j vi-down-line-or-history

# enable advanced globbing
setopt extended_glob

function die {
    echo $1
    return 1
}

# this fixes switching between vi-modes
bindkey -rpM viins '^['

# enable advanced globbing
setopt extended_glob

# useful function to update zshrc for adm user
function update_dotfiles_adm_user {

    BRANCHES=(trunk branches/testing branches/production)
    DOTFILES=(
        bash_profile
        bashrc
        inputrc
        lscolorsrc
        vimrc
        zshrc
        vim/colors/xterm16.vim
        vim/colors/jellybeans.vim
        vim/ftdetect/puppet.vim
        vim/syntax/puppet.vim
        vim/after/plugin/TabularMaps.vim
        vim/after/plugin/solarized.vim
        vim/autoload/tabular.vim
        vim/plugin/Tabular.vim
    )

    # copy dotfiles to adm env/ directory
    for dotfile in $DOTFILES; do
        for branch in $BRANCHES; do
            DOTFILE_PATH="$HOME/.$dotfile $HOME/work/systems/pm/fileserver/$branch/dist/user/robwadm/env/`dirname $dotfile`"

            [[ ! -d "$DOTFILE_PATH" ]] && mkdir -p $DOTFILE_PATH

            cp -v $HOME/.$dotfile $HOME/work/systems/pm/fileserver/$branch/dist/user/robwadm/env/$dotfile
        done
    done

    UPDATED_DOTFILES=""
    NEW_DOTFILES=""

    # commit files (one commit per file is inefficient but whatever..)
    for branch in $BRANCHES; do
        for new_dotfile in `svn status $HOME/work/systems/pm/fileserver/$branch/dist/user/robwadm/env/|grep '^?'|awk '{print $2}'`; do
            NEW_DOTFILES=($new_dotfile $NEW_DOTFILES)
        done

        for updated_dotfile in `svn status $HOME/work/systems/pm/fileserver/$branch/dist/user/robwadm/env/|awk '{print $2}'`; do
            UPDATED_DOTFILES=($updated_dotfile $UPDATED_DOTFILES)
        done
    done

    # add any new files/dirs to svn
    if [ ! -z "$NEW_DOTFILES" ]; then
        echo NEW DF $NEW_DOTFILES
        for dotfile in $NEW_DOTFILES; svn add $dotfile
    fi

    # commit any changed dotfiles
    if [ ! -z "$UPDATED_DOTFILES" ]; then
        svn status $UPDATED_DOTFILES
        svn ci -m 'updated robwadm dotfiles..' $UPDATED_DOTFILES
    fi
}

function update_dotfiles {
    cd; curl -#L https://github.com/roobert/dotfiles/tarball/master | tar -xzv --strip-components 1
    #bash <(wget -O - df.dust.cx)
}

# Examples:
#
#    gh_checkin dotfiles
#    gh_checkin bin
#
function gh_checkin {

       REPOS="$1"
     TMP_DIR="$HOME/tmp"
    WORK_DIR="$TMP_DIR/$REPOS"

    case $REPOS in
        dotfiles)
            SOURCE_DIR=~
        ;;
        bin)
            SOURCE_DIR=~/bin
        ;;
        *)
            die "unknown repository: $REPOS"
        ;;
    esac

    [[ ! -d $TMP_DIR ]] && die "no such directory \$TMP_DIR: $TMPDIR"

    if [[ -d $WORK_DIR ]]; then
        ( cd $WORK_DIR && git pull )
    else
        git clone ssh://git@github.com/roobert/dotfiles $WORK_DIR
    fi

    for file in `find $WORK_DIR -type f -not -wholename "$WORK_DIR/.git/*" -not -iwholename "$WORK_DIR/.git"`; do

        SRC_FILE=`echo $file | sed "s|$WORK_DIR/||"`

        diff $file $SOURCE_DIR/$SRC_FILE

        # only copy changed files..
        [[ $? != 0 ]] && echo cp -v $SOURCE_DIR/$SRC_FILE $WORK_DIR
    done

    echo "( cd $WORK_DIR && git commit -am 'updated' && git push )"
}

function install_common_tools {
    sudo apt-get install git subversion vim zsh tree colordiff ncdu htop ack-grep
}

function install_common_tools_osx {
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
    brew install zsh coreutils wget
}
