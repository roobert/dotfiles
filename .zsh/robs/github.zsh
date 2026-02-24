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
      _git_commands
      return
      ;;
  esac
}
compdef _dotfiles dotfiles
