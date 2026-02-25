#!/usr/bin/env bash
# Install Xcode CLI tools and Homebrew

# Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  echo "==> Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "    Press any key once the installation is complete."
  read -n 1 -s
else
  echo "    Xcode Command Line Tools already installed."
fi

# Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "    Homebrew already installed."
fi
