# fetch the stuff i like from oh-my-zsh
function get_stuff_from_oh_my_zsh () {
  omz_stuff=(lib/grep.zsh lib/spectrum.zsh lib/completion.zsh plugins/vi-mode plugins/git plugins/nyan)
  omz_tmp_dir=`mktemp -d`

  git clone https://github.com/robbyrussell/oh-my-zsh.git $omz_tmp_dir

  for dir in $omz_stuff; cp -vR $omz_tmp_dir/$dir .

  rm -rvf $omz_tmp_dir
}

#
# shortcuts to install some useful tools..
#

# install: subversion vim zsh tree colordiff ncdu htop ack-grep apt-file notion rxvt-unicode-256color
function install_common_tools {
  sudo apt-get install git subversion vim zsh tree colordiff ncdu htop ack-grep apt-file notion rxvt-unicode-256color autocutsel tcpdump
}

alias install_flash='sudo apt-get install ubuntu-restricted-extras'

# install some ruby tools and gems: rbenv, ruby-build, awesome_print net-http-spy wirble bond boson looksee
function install_ruby_tools {
  if ! dpkg -l git > /dev/null 2>&1; then
    sudo apt-get install git
  fi

  if ! dpkg -l libreadline-dev > /dev/null 2>&1; then
    sudo apt-get install libreadline-dev
  fi

  if ! dpkg -l zlib1g-dev > /dev/null 2>&1; then
    sudo apt-get install zlib1g-dev
  fi

  if ! dpkg -l libssl-dev > /dev/null 2>&1; then
    libssl-dev
  fi

  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  sudo gem install awesome_print net-http-spy wirble bond boson looksee
}

# install zsh, coreutils, wget and homebrew
function install_common_tools_osx {
  ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
  brew install zsh coreutils wget
}

# egrep -- ignore .svn dirs
function g {
   egrep --exclude-dir=\.svn $*
}

zle      -N   fzf-file-widget
bindkey '^F' fzf-file-widget

function wrap-cli-input () {
  BUFFER="\$($BUFFER)"
}
zle -N wrap-cli-input
bindkey -M viins '^g' wrap-cli-input

function prepend-cli-input-vim () {
  BUFFER="vim $BUFFER"
}
zle -N prepend-cli-input-vim
bindkey -M viins '^e' prepend-cli-input-vim

# easily search zsh man pages
function zman {
  PAGER="less -g -s '+/^       "$1"'" man zshall
}

# find
function f {
  case $# in
    1) find . -name $1 ;;
    2) find $1 -name $2 ;;
    *) echo "Invalid number of arguments!" >&2; return 1 ;;
  esac
}

# find wild
function fw {
  case $# in
    1) find . -name "*$1*" ;;
    2) find $1 -name "*$2*" ;;
    *) echo "Invalid number of arguments!" >&2; return 1 ;;
  esac
}

# highlight a string
function hl {
  SEARCH_STRING="$1"

  if [[ $# -eq 0 ]]; then
    echo "not enough arguments!"
    return 1
  elif [[ $# -eq 1 ]]; then
    FILES="-"
  else
    FILES="$@"
  fi

  egrep "${SEARCH_STRING}|^" $FILES
}

# merge any local ssh configs into main config - for stuff that would be silly to store in github
function ssh_merge_config {
  if ls $HOME/.ssh-* > /dev/null 2>&1; then
    echo "merging ssh configs.."
    cat $HOME/.ssh-* >> $HOME/.ssh/config
  else
    echo "no ssh configs to merge"
  fi
}

function ssh_unmerge_config {
  gh_pull dotfiles
  cp -v ~/tmp/dotfiles/.ssh/config ~/.ssh/config
}

# create an html file containing images
function make_html_index {
  rm -vi index.html
  for f in *; echo "<a href=\"$f\"><img src=\"$f\"></a>" >> index.html
  echo "<style>img { width: 800px; }</style>" >> index.html
}
alias mhi=make_html_index

# du -- sorted by size
function du_sort {
  if echo | sort -h > /dev/null 2>&1; then
    du -sh $* | sort -h
  else
    # stolen from: http://www.bashoneliners.com/main/oneliner/102/
    # older versions of sort don't have the -h flag that allows clever sorting of du -h output, e.g: du -sh | sort -h
    for i in G M K; do du -hsx -- $* | grep --color=never "[0-9]$i\b" | sort -nr; done | tac 2>/dev/null
  fi
}
alias dus=du_sort
alias ds=du_sort

# zsh man pages are missing from ubuntu 14.04: https://bugs.launchpad.net/ubuntu/+source/zsh/+bug/1242108
function install_zsh_docs {
curl -L http://sourceforge.net/projects/zsh/files/zsh/5.0.2/zsh-5.0.2.tar.gz/download | sudo tar vzxf - -C /usr/share/man/man1 --wildcards --no-anchored '*.1' --strip-components 2
}


function install_lnav {
  if which xmllint > /dev/null; then
    LNAV_VERSION=0.7.0
  else
    LNAV_VERSION=$(curl http://lnav.org/downloads/ -s  | xmllint --xpath 'string(//div[@id="content"]//div[@class="sqs-block-content"]/p/strong)' --format --nowarning --html - 2> /dev/null | awk '{ print $2  }' | tr -d ':')
0.7.0 
  fi

  TMP=$(tempfile)
  wget -q -O $TMP https://github.com/tstack/lnav/releases/download/v${LNAV_VERSION}/lnav-${LNAV_VERSION}-linux-64bit.zip
  unzip -d ~/bin $TMP lnav-${LNAV_VERSION}/lnav
}

# create (nested) dir and change to it
function mcd {
  mkdir -vp $1 && cd $1
}

function install_jq {
  mkdir -v ~/bin
  curl http://stedolan.github.io/jq/download/linux64/jq > ~/bin/jq
  chmod +x ~/bin/jq
}

# after this select 'fixed semicondensed 10' from gnome terminal settings
function install_gnome_terminal_bitmap_fonts {
  sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
  sudo ln -s /etc/fonts/conf.avail/70-yes-bitmaps.conf /etc/fonts/conf.d/70-yes-bitmaps.conf
  sudo dpkg-reconfigure fontconfig fontconfig-config
}

function keygen {
  NAME=$1
  if [[ -z $NAME ]]; then
    echo "specify key name!"
    return 1
  fi
  ssh-keygen -t rsa -b 4096 -C "id_rsa-$NAME" -f ~/.ssh/id_rsa-$NAME -q -N ""
}
