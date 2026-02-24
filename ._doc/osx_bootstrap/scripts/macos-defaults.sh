#!/usr/bin/env bash
# macOS system defaults

# Accessibility: reduce motion (no animation on desktop switch)
sudo defaults write com.apple.universalaccess reduceMotion -bool true

# Keyboard: disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Keyboard: disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Keyboard: disable double-space period shortcut
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Keyboard: fast key repeat rate (2=fastest GUI setting, 30ms)
defaults write NSGlobalDomain KeyRepeat -int 2

# Keyboard: short initial key repeat delay (15=fastest GUI setting, 225ms)
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Keyboard: disable press-and-hold for accent characters (enables key repeat)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Menu bar clock: show seconds, 24h format, day and date
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM HH:mm:ss"
defaults write com.apple.menuextra.clock ShowSeconds -bool true

# Chrome: disable swipe-to-navigate
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

# AltTab: show on screen showing AltTab, hide minimised/hidden/fullscreen windows
defaults write com.lwouis.alt-tab-macos showOnScreen -int 1
defaults write com.lwouis.alt-tab-macos hideMinimizedWindows -int 1
defaults write com.lwouis.alt-tab-macos hideHiddenWindows -int 1
defaults write com.lwouis.alt-tab-macos hideFullscreenWindows -int 1
defaults write com.lwouis.alt-tab-macos showTabsAsWindows -bool false

echo "    System defaults applied."
