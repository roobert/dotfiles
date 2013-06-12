# useful function to update zshrc for adm user
# FIXME: simplify by doing: cd to trunk/, gh_fetch, sf . both -f, svn-addall; svn commit
function update_dotfiles-adm_user {

  BRANCHES=(trunk branches/testing branches/production)
  DOTFILES=(
    .bash_profile
    .bashrc
    .zshrc
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

