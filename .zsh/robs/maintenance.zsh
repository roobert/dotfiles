if [[ -f "$HOME/.zsh_maintenance_required" ]]; then
  echo "\033[33m── updates available ──\033[0m"
  cat "$HOME/.zsh_maintenance_required"
  echo ""
  read -q "reply?Run upgrades now? (N/y) "
  echo ""
  if [[ "$reply" =~ ^[Yy]$ ]]; then
    echo "==> brew upgrade"
    brew upgrade
    echo "==> mise upgrade"
    mise upgrade
    rm -f "$HOME/.zsh_maintenance_required"
    echo "\033[32mDone.\033[0m"
  fi
fi
