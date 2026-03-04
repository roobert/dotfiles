#!/usr/bin/env bash
# Install full Xcode.app from the Mac App Store

XCODE_APP_STORE_ID=497799835

# Ensure mas is available (already in Brewfile, but needed if running standalone)
if ! command -v mas &>/dev/null; then
  echo "    Installing mas..."
  brew install mas
fi

if [[ -d "/Applications/Xcode.app" ]]; then
  echo "    Xcode.app already installed."
else
  echo "    Installing Xcode.app from the App Store (sudo password required)..."
  sudo mas install "$XCODE_APP_STORE_ID"
fi

# Accept license and configure developer directory
if [[ -d "/Applications/Xcode.app" ]]; then
  sudo xcodebuild -license accept

  echo "    Switching xcode-select to Xcode.app..."
  sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

  echo "    Running first launch setup..."
  sudo xcodebuild -runFirstLaunch
fi
