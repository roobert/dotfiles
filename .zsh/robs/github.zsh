dotfiles() {
  GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME command git "$@"
}

_dotfiles() {
  local -x GIT_DIR=$HOME/.dotfiles
  local -x GIT_WORK_TREE=$HOME

  # For subcommands that take file paths, complete with tracked/modified files
  case "${words[2]}" in
    add)
      local -a files
      files=(${(f)"$(command git --git-dir=$HOME/.dotfiles --work-tree=$HOME diff --name-only 2>/dev/null)"})
      _describe 'modified files' files
      return
      ;;
    diff|checkout|restore)
      local -a files
      files=(${(f)"$(command git --git-dir=$HOME/.dotfiles --work-tree=$HOME diff --name-only 2>/dev/null)"})
      _describe 'modified files' files
      return
      ;;
    *)
      local -a subcmds
      subcmds=(
        add diff status commit push pull log checkout restore
        branch merge rebase stash show tag reset fetch remote
      )
      _describe 'git commands' subcmds
      return
      ;;
  esac
}
compdef _dotfiles dotfiles
