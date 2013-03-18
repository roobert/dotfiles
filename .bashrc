# .bashrc

# stop here if not a shell
if [ ! -n "$PS1" ]; then return; fi

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
if [ "$TERM" == "xterm" ] || [ "$TERM" == "mlterm" ] || [ "$TERM" == "rxvt-unicode-256color" ]; then
  export TERM="xterm-256color"
fi

# include ~/bin in path
if [ -d "$HOME/bin" ]; then
  export PATH="$PATH:$HOME/bin"
fi

# Update LINES and COLUMNS after every command
shopt -s checkwinsize

# Reset
Color_Off='\e[0m'       # Text Reset

# `colour #` colour chart:  http://upload.wikimedia.org/wikipedia/commons/9/95/Xterm_color_chart.png
function color () { echo -ne "\[\033[38;5;$1m\]"; }
function ncolor () { echo -ne "\[\e[0m\]"; }

PHOST="`color 104`\h`ncolor`"
PWHERE="`color 219`\w`ncolor`"
PPROMPT="`color 40`\\$`ncolor` "
case `whoami` in
    rw|robw)
        PUSER="`color 119`\u`ncolor`"
        
    ;;
    robwadm|root)
        PUSER="`color 161`\u`ncolor`"
        PPROMPT="`color 160`\\$`ncolor` "
    ;;
esac

if [ "$HOSTNAME" == "disco" ]; then
    PHOST="`color 200`\h`ncolor`"
fi

PS1="$PUSER $PHOST $PWHERE $PPROMPT"

# Colour settings
alias vi="vim"
alias vim="vim -T xterm-256color"
alias grep="grep --color"
alias screen="TERM=xterm screen"
# ls -F for details
alias ls="ls --color=yes"
# allow ansi colour escape sequences (for svn diff when diff_cmd is set
# in .subversion/config
alias less="less -R"
# force-allocate pseudo-tty
alias ssh="ssh -t"

export LESS="-REX" # allow escape sequences to be interpreted properly

# don't let stty handle ^W so that /'s and -'s are included etc.
stty werase undef
bind '"\C-w":backward-kill-word'

# Prettier directory colours
# https://github.com/trapd00r/LS_COLORS
eval $( dircolors -b $HOME/.lscolorsrc)

# ruby stuff
if which rbenv 2> /dev/null; then eval "$(rbenv init -)"; fi

# don't include .svn in tab complete
export FIGNORE=".svn"

if [ -d "$HOME/work/systems/pm" ]; then
    export CDPATH=".:$HOME/work/systems/pm/:$HOME/work/systems/trunk"
fi

# bookmarky type stuff?

BOOKMARKS=$HOME/.bmrc

function die {
    echo $1
}

function bm {

    case $1 in
        a|add)
            if [ "$2" == "." ]; then
                echo "export `basename $PWD`=$PWD" >> $BOOKMARKS
                source $BOOKMARKS

                return
            fi

            if [ -z "$2" ]; then
                die "supply name for bookmark"
            fi

            if [ -z "$3" ]; then
                die "supply location for bookmark"
            fi

            echo "export $2=$3" >> $BOOKMARKS
        ;;
        d|del|delete|rem|r|remove)
            # FIXME: should probably unset too
            cp $BOOKMARKS $BOOKMARKS-old
            cat $BOOKMARKS-old | grep -v $2 > $BOOKMARKS
        ;;
        *)
            cat $BOOKMARKS
            return
        ;;
    esac
}

if [ -f "$HOME/.bmrc" ]; then
    source ~/.bmrc
fi

function udf { 
    if [ "$1" == "adm" ]; then
        _ud_adm_path trunk
        _ud_adm_path branches/testing
        _ud_adm_path branches/production
    else
        bash <(wget -O - df.dust.cx)
    fi
}

function _ud_adm_path {
    cp -v ~/.vimrc ~/work/systems/pm/fileserver/$1/dist/user/robwadm/env/vimrc;
    cp -vr ~/.vim/* ~/work/systems/pm/fileserver/$1/dist/user/robwadm/env/vim/;
    cp -v ~/.bashrc ~/work/systems/pm/fileserver/$1/dist/user/robwadm/env/bashrc;
    cp -v ~/.lscolorsrc ~/work/systems/pm/fileserver/$1/dist/user/robwadm/env/lscolorsrc;
    cp -v ~/.inputrc ~/work/systems/pm/fileserver/$1/dist/user/robwadm/env/inputrc;
    cp -v ~/.bash_profile ~/work/systems/pm/fileserver/$1/dist/user/robwadm/env/bash_profile;
    svn ci -m 'updated dotfiles' ~/work/systems/pm/fileserver/$1/dist/user/robwadm/env/
}

if [ -f /etc/bash_completion ] && [ -f $HOME/.ssh/known_hosts ]; then
    complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
fi
