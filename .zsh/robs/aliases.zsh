# aliases

# system tools
alias s="sudo"
alias ls="ls --color=auto"
alias hist="history 1"
alias m="mount | column -t"
alias am="alsamixer -D pulse"
alias screen="TERM=xterm screen"
alias ssh="ssh -t"

# shortcuts
alias haste_work="pasti"
alias rubygems_login="curl -u roobert https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials"
alias empty_trash="rm -rf ~/.local/share/Trash"

# vim
alias vi="vim"
alias vim="vim -T xterm-256color -p"

# git
alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gd="gl -p"
alias gup='git commit -am "updated" && git push'

# connect to os X and login to vagrant instances
alias vpm="ssh rpro -t 'cd vagrant-puppetmaster; vagrant ssh'"
alias vpa="ssh rpro -t 'cd vagrant-puppet-client; vagrant ssh'"

# ps stuff
export PS_FORMAT="user,pid,args"
alias ps='ps ww'                     # ps - always assume unlimited width
alias p='ps axcwwf'                  # p  - display all, 
alias pu='ps -o user,pid,command ww' # pu

# ask_kill shortcuts
alias ak='$HOME/bin/ask_kill.rb'
alias akc='$HOME/bin/ask_kill.rb -c'
alias aku='$HOME/bin/ask_kill.rb -u'
alias akp='$HOME/bin/ask_kill.rb -p'

# puppet
alias -g PUPPET_FILTER="sed -e 's/\(.*\(notice:\|info:\|err:\|warning:\).*\)/\1\n/'"
alias puppet_alltags="puppet_alltags -f  | PUPPET_FILTER"
alias puppet_autoapply="puppet_autoapply | PUPPET_FILTER"
alias puppet_noop="puppet_noop           | PUPPET_FILTER"
alias pa="puppet_alltags"
alias pt="puppet_tags"
alias paa="puppet_autoapply"
alias pprod="cd trunk branches/prod"
alias ptest="cd trunk branches/test"

# ffs
alias ffs="sudo !!"

# reload zshrc
alias rzsh="exec zsh -l"
alias rz="rzsh"
alias zr="rz"

# use facter to display lsbdistcodename
alias lsbdc="facter lsb lsbdistcodename | tail -n 1 | COL3"

# configure some stuff
export LESS="-R" # allow escape sequences to be interpreted properly
export EDITOR="vim"
export GREP_OPTIONS='--color=always'
export GREP_COLOR='1;32'

# camera
alias getpics="gphoto2 --get-all-files"

# nagios
alias nrpe-runner="nrpe-runner -d /etc/nagios/nrpe.conf.d"

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

alias c2="../../"
alias c3="../../../"
alias c4="../../../../"
alias c5="../../../../../"
alias c6="../../../../../../"
alias c7="../../../../../../../"
alias c8="../../../../../../../../"
alias c9="../../../../../../../../../"

alias ansible="ansible -i $HOME/.ansible_hosts"
alias ansible-playbook="ansible-playbook -i $HOME/.ansible_hosts"

# whats the diff between these two clipboards?
#alias copy="xsel --clipboard --input"
#alias paste="xsel --clipboard --output"
alias copy="xclip -i -selection p"
alias paste="xclip -o -selection p"

# apt
alias add="sudo apt-get install"
alias remove="sudo apt-get remove"
alias purge="sudo apt-get purge"
alias update="sudo apt-get update"
alias search="sudo apt-cache search"
alias dsearch="dpkg -l | grep"

# mute
alias mute='amixer sset Master toggle'
alias screenoff='xset dpms force off'

alias sus='su sysadmin'
