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
function cheesy-ctrlp () {
  BUFFER='vim +:CtrlP'
  zle accept-line
}

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
function sp { grep -R $1 ~modules/*/trunk ~nodes ~site }

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
