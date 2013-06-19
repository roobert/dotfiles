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
Color_Off='\e[0m'

# colour chart:  http://upload.wikimedia.org/wikipedia/commons/9/95/Xterm_color_chart.png
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

if [ -f /etc/bash_completion ] && [ -f $HOME/.ssh/known_hosts ]; then
    complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
fi
