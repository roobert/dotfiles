#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> macOS Setup"
echo ""

# Hostname
current_hostname=$(scutil --get ComputerName 2>/dev/null || hostname)
read -p "==> Hostname [mbp0]: " hostname
hostname="${hostname:-mbp0}"
if [[ "$hostname" != "$current_hostname" ]]; then
  sudo scutil --set ComputerName "$hostname"
  sudo scutil --set HostName "$hostname"
  sudo scutil --set LocalHostName "$hostname"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$hostname"
  echo "    Hostname set to $hostname."
else
  echo "    Hostname already $hostname."
fi

# Timezone
current_tz=$(systemsetup -gettimezone 2>/dev/null | awk -F': ' '{print $2}' || echo "unknown")
read -p "==> Timezone [Europe/London]: " timezone
timezone="${timezone:-Europe/London}"
if [[ "$timezone" != "$current_tz" ]]; then
  sudo systemsetup -settimezone "$timezone"
  echo "    Timezone set to $timezone."
else
  echo "    Timezone already $timezone."
fi

# Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  echo "==> Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "    Press any key once the installation is complete."
  read -n 1 -s
fi

# Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "==> Installing packages from Brewfile..."
brew bundle --file="${SCRIPT_DIR}/Brewfile"

echo "==> Configuring macOS system defaults..."
source "${SCRIPT_DIR}/scripts/macos-defaults.sh"

echo "==> Configuring keyboard (§/\` swap)..."
source "${SCRIPT_DIR}/scripts/keyboard-swap.sh"

echo "==> Configuring iTerm2..."
source "${SCRIPT_DIR}/scripts/iterm2.sh"

echo "==> Configuring Mission Control hotkeys..."
source "${SCRIPT_DIR}/scripts/mission-control.sh"

echo "==> Configuring mise + uv..."
source "${SCRIPT_DIR}/scripts/mise-setup.sh"

echo "==> Setting up weekly maintenance check..."
source "${SCRIPT_DIR}/scripts/maintenance-launchd.sh"

echo "==> Setting up fzf..."
"$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish

echo ""
echo "==> Done! Some changes require a logout/restart to take effect."
echo "    Manual steps remaining:"
echo "    - Create multiple desktops in Mission Control (for ctrl+N shortcuts)"
echo "    - Set up Aggregate Sound Device in Audio MIDI Setup"
echo "    - Switch to Australian keyboard layout in System Settings"
echo "    - gh auth login"
