[[ -o interactive ]] || return

if [[ -f "$HOME/.zsh_maintenance_required" ]]; then
  # Show the page at most once a week: skip if we've shown it within the
  # last 7 days. (Nmw-1) matches the marker only if modified < 1 week ago.
  shown_marker="$HOME/.zsh_maintenance_shown"
  if [[ -n $shown_marker(Nmw-1) ]]; then
    return
  fi
  touch "$shown_marker"

  print $'\033[33m── updates available ──\033[0m'
  cat "$HOME/.zsh_maintenance_required"
  print ""
  read -q "reply?Run upgrades now? (N/y) "
  print ""
  if [[ "$reply" =~ ^[Yy]$ ]]; then
    # Clear the flag before upgrading (which can take minutes) so any shell
    # opened mid-upgrade doesn't see a pending update and re-prompt. Keep the
    # marker fresh so the weekly gate still holds for the next check cycle.
    rm -f "$HOME/.zsh_maintenance_required"
    print "==> brew upgrade"
    brew upgrade
    print "==> mise upgrade"
    mise upgrade
    print $'\033[32mDone.\033[0m'
  fi
fi
