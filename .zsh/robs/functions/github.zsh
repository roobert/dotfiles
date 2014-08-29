
# Examples:
#
#   gh_fetch <repo> <path>
#
function gh_fetch {

  REPOS="$1"
  TARGET="$2"

  # TODO: hmm...
  # if $0 == gh_install / gh_update then $TARGET = $HOME ?

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

  # no --strip-components option for older versions of tar (tar (GNU tar) 1.14)
  tar --help | grep strip-components > /dev/null 2>&1
  if [[ $? == 0 ]]; then
    STRIP_CMD="--strip-components"
  else
    STRIP_CMD="--strip-path"
  fi

  # insecure option is necessary for some reason.. -m means dont care about mtime
  curl -sL --insecure https://github.com/roobert/$REPOS/tarball/master \
  | tar -xzv -m $STRIP_CMD 1 --exclude=README.md -C $TARGET
}

alias gh_install="gh_fetch"
alias gh_update="gh_fetch"
alias update_dotfiles="gh_fetch dotfiles $HOME && chmod -R 700 $HOME/.ssh"

# Examples:
#
#   gh_pull <repo>
#
function gh_pull {
  REPOS="$1"
  TMP_DIR="$HOME/tmp"

  # either clone or update repo depending on whether it's already checked out
  if [[ -d $TMP_DIR/$REPOS ]]; then
    git --git-dir=$TMP_DIR/$REPOS/.git --work-tree=$TMP_DIR/$REPOS/  pull
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
    if [[ -d "$old_file" ]]; then
      continue
    fi

    new_file=`echo "$old_file" | sed "s|$WORK_DIR/|$SOURCE_DIR|"`

    if [[ ! -f "$new_file" ]]; then
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

  echo "# removing temporary files.."
  rm -rf $HOME/tmp/$REPOS
}

function gh_add_dotfiles {
  FILE="$1"

  test -f "$1" || { echo "no such file: $1"; exit 1 }

  gh_pull dotfiles

  # work out directory relative to zsh root
  FILE_LOCATION=$(readlink -f $FILE | sed 's/.*\.zsh\//.zsh\//')

  cp -v $FILE ~/tmp/dotfiles/${FILE_LOCATION}

  (
    cd ~/tmp/dotfiles/
    git add ${FILE_LOCATION}
    git commit -m 'added file'
    git push
  )
}

function gh_remove_dotfiles {
  FILE="$1"

  test -f "$1" || { echo "no such file: $1"; exit 1 }

  gh_pull dotfiles

  # work out directory relative to zsh root
  FILE_LOCATION=$(readlink -f $FILE | sed 's/.*\.zsh\//.zsh\//')

  (
    cd ~/tmp/dotfiles/
    git rm ${FILE_LOCATION}
    git commit -m "removed file"
    git push
  )
}
