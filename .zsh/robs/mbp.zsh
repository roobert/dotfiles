_mbp() {
  local -a top
  top=(brew claude dfs status help)

  if (( CURRENT == 2 )); then
    _describe 'mbp commands' top
    return
  fi

  case "${words[2]}" in
    brew)
      if (( CURRENT == 3 )); then
        local -a brew_cmds
        brew_cmds=(list install remove)
        _describe 'brew subcommands' brew_cmds
        return
      fi

      case "${words[3]}" in
        install)
          # support --cask flag
          if [[ "${words[CURRENT]}" == -* ]]; then
            _arguments '--cask[Install a cask instead of a formula]'
            return
          fi
          # if --cask is present anywhere, complete casks; otherwise formulae
          if (( ${words[(I)--cask]} )); then
            local -a casks
            casks=(${(f)"$(brew casks 2>/dev/null)"})
            _describe 'casks' casks
          else
            local -a formulae
            formulae=(${(f)"$(brew formulae 2>/dev/null)"})
            _describe 'formulae' formulae
          fi
          ;;
        remove)
          local brewfile="$HOME/._dotfiles/osx_bootstrap/Brewfile"
          local -a entries
          entries=(${(f)"$(sed -n 's/^[a-z]* "\(.*\)"/\1/p' "$brewfile" 2>/dev/null)"})
          _describe 'Brewfile entries' entries
          ;;
      esac
      ;;
    dfs)
      if (( CURRENT == 3 )); then
        local -a git_cmds
        git_cmds=(status diff commit push log add checkout restore branch)
        _describe 'git commands' git_cmds
        return
      fi
      # For subcommands that take file args, complete modified dotfiles
      case "${words[3]}" in
        add|diff|checkout|restore)
          local -a files
          files=(${(f)"$(command git --git-dir=$HOME/.dotfiles --work-tree=$HOME diff --name-only 2>/dev/null)"})
          _describe 'modified files' files
          ;;
      esac
      ;;
    help) ;;
  esac
}
compdef _mbp mbp
