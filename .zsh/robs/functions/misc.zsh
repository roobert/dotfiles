# stuff i like from oh-my-zsh
function get_stuff_from_oh-my-zsh () {
  omz_stuff=(lib/grep.zsh lib/spectrum.zsh lib/completion.zsh plugins/vi-mode plugins/git plugins/nyan)
  omz_tmp_dir=`mktemp -d`

  git clone https://github.com/robbyrussell/oh-my-zsh.git $omz_tmp_dir

  for dir in $omz_stuff; cp -vR $omz_tmp_dir/$dir .

  rm -rvf $omz_tmp_dir
}

#
# shortcuts to install some useful tools..
#

# list useful stuff like aliases and functions.. make this into something more useful?
function help {
  echo "# functions"
  grep '^function' ~/.zshrc | awk '{ print $2 }'

  echo "# aliases"
  alias
}

function install_common_tools {
  sudo apt-get install git subversion vim zsh tree colordiff ncdu htop ack-grep apt-file
}

alias install_flash='sudo apt-get install ubuntu-restricted-extras'

function install_ruby_tools {
  sudo apt-get install rbenv ruby-build
  sudo gem install awesome_print net-http-spy wirble bond boson looksee
}

function install_common_tools_osx {
  ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
  brew install zsh coreutils wget
}

function g {
   egrep --exclude-dir=\.svn $* | grep -v grep
}

# semantico svn stuff
export SEMANTICO_SVN_SERVER="https://svn.semantico.net/repos/"

function svn.sem {
  if [[ $# -ne '2' ]]; then
    echo "$0 <command> <repos>"
    die  "e.g: $0 checkout systems"
  fi

  svn $1 $SEMANTICO_SVN_SERVER/$2
}

# mattf props! - open vim ctrl-p with ^P
#function cheesy-ctrlp () {
#  BUFFER='vim +:CtrlP'
#  zle accept-line
#}

zle -N cheesy-ctrlp cheesy-ctrlp
bindkey -M viins '^P' cheesy-ctrlp

# more mattf magic
function wrap-my-shizz () {
  BUFFER="vim \$($BUFFER)"
}

zle -N wrap-my-shizz
bindkey -M viins '^B' wrap-my-shizz


function svn.add_all () {
  for f in `svn status|grep \^\?|COL2`; svn add $f
}

# search puppet
function sp { grep -R $* ~modules/*/trunk ~nodes ~site }

# stuff stolen from: http://chneukirchen.org/blog/archive/2012/02/10-new-zsh-tricks-you-may-not-know.html

# toggle vi with ctrl-z
function foreground-vi {
  fg %vi
}
zle -N foreground-vi
bindkey '^Z' foreground-vi

# easily search zsh man pages
function zman {
  PAGER="less -g -s '+/^       "$1"'" man zshall
}

# stolen from: http://www.bashoneliners.com/main/oneliner/102/
# older versions of sort don't have the -h flag that allows clever sorting of du -h output, e.g: du -sh | sort -h
function du.sorted {
  for i in G M K; do du -hsx * | grep "[0-9]$i\b" | sort -nr; done | tac 2>/dev/null
}

# find
function f {
  case $# in
    1) find . -name $1 ;;
    2) find $1 -name $2 ;;
    *) echo "Invalid number of arguments!" >&2; exit 1 ;;
  esac
}

# find wild
function fw {
  case $# in
    1) find . -name "*$1*" ;;
    2) find $1 -name "*$2*" ;;
    *) echo "Invalid number of arguments!" >&2; exit 1 ;;
  esac
}

# highlight
function hl {
  SEARCH_STRING="$1"

  if [[ $# -eq 0 ]]; then
    echo "not enough arguments!"
    exit 1
  elif [[ $# -eq 1 ]]; then
    FILES="-"
  else
    FILES="$@"
  fi

  egrep "${SEARCH_STRING}|^" $FILES
}

function si {
  if [[ $# -gt 0 ]]; then
    svn ci -m $*
  else
    svn ci -m ''
  fi
}

function ssh_merge_config {
  # merge any local ssh configs into main config - for stuff that would be silly to store in github                                                           
  if ls $HOME/.ssh-* > /dev/null 2>&1; then
    echo "merging ssh configs.."
    cat $HOME/.ssh-* >> $HOME/.ssh/config
  else
    echo "no ssh configs to merge"
  fi
}

function make_html_index {
  for f in *; echo "<img src=\"$f\">" >> index.html
  echo "<style>img { width: 800px; }</style>" >> index.html
}
