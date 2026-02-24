[[ -o interactive ]] || return

if [[ -f "$HOME/.zsh_maintenance_required" ]]; then
  print $'\033[33m── updates available ──\033[0m'
  cat "$HOME/.zsh_maintenance_required"
  print ""
  read -q "reply?Run upgrades now? (N/y) "
  print ""
  if [[ "$reply" =~ ^[Yy]$ ]]; then
    print "==> brew upgrade"
    brew upgrade
    print "==> mise upgrade"
    mise upgrade
    rm -f "$HOME/.zsh_maintenance_required"
    print $'\033[32mDone.\033[0m'
  fi
fi
