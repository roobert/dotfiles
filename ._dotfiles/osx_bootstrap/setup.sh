#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ERRORS=0

run_step() {
  local name="$1"
  local script="$2"
  echo "==> ${name}..."
  if source "${script}"; then
    :
  else
    echo "    WARNING: ${name} had errors, continuing..."
    ERRORS=$((ERRORS + 1))
  fi
}

echo "==> macOS Setup"
echo ""

run_step "Pre-setup manual steps" "${SCRIPT_DIR}/scripts/pre-setup.sh"
run_step "Configuring hostname and timezone" "${SCRIPT_DIR}/scripts/hostname-timezone.sh"
run_step "Installing Xcode CLI tools and Homebrew" "${SCRIPT_DIR}/scripts/xcode-homebrew.sh"
run_step "Installing packages from Brewfile" "${SCRIPT_DIR}/scripts/brew-bundle.sh"
run_step "Configuring macOS system defaults" "${SCRIPT_DIR}/scripts/macos-defaults.sh"
run_step "Configuring keyboard (§/\` swap)" "${SCRIPT_DIR}/scripts/keyboard-swap.sh"
run_step "Configuring iTerm2" "${SCRIPT_DIR}/scripts/iterm2.sh"
run_step "Configuring Mission Control hotkeys" "${SCRIPT_DIR}/scripts/mission-control.sh"
run_step "Configuring mise + uv" "${SCRIPT_DIR}/scripts/mise-setup.sh"
run_step "Setting up weekly maintenance check" "${SCRIPT_DIR}/scripts/maintenance-launchd.sh"
run_step "Setting up fzf" "${SCRIPT_DIR}/scripts/fzf-setup.sh"

echo ""
if [[ $ERRORS -gt 0 ]]; then
  echo "==> Done with ${ERRORS} warning(s). Review output above."
else
  echo "==> Done!"
fi
echo "    Some changes require a logout/restart to take effect."
echo "    Manual steps remaining:"
echo "    - Set up Aggregate Sound Device in Audio MIDI Setup"
echo "    - Switch to Australian keyboard layout in System Settings"
echo "    - gh auth login"
