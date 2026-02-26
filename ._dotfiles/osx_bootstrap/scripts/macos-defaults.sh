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

# Keyboard: fast key repeat rate (2 = fast, 1 = fastest, default = 6)
defaults write NSGlobalDomain KeyRepeat -int 2

# Keyboard: short delay until repeat (30 = short, 15 = shortest, default = 68)
defaults write NSGlobalDomain InitialKeyRepeat -int 30

# Trackpad: disable "natural" scrolling (use traditional scroll direction)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Menu bar clock: show seconds, 24h format, day and date
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM HH:mm:ss"
defaults write com.apple.menuextra.clock ShowSeconds -bool true

# Menu bar: show Sound control
defaults -currentHost write com.apple.controlcenter Sound -int 18
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true

# Menu bar: hide Spotlight
defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1

# Desktop: disable click wallpaper to reveal desktop
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Chrome: disable swipe-to-navigate
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

# AltTab: show on screen showing AltTab, hide minimised/hidden/fullscreen windows
defaults write com.lwouis.alt-tab-macos showOnScreen -int 1
defaults write com.lwouis.alt-tab-macos hideMinimizedWindows -int 1
defaults write com.lwouis.alt-tab-macos hideHiddenWindows -int 1
defaults write com.lwouis.alt-tab-macos hideFullscreenWindows -int 1
defaults write com.lwouis.alt-tab-macos showTabsAsWindows -bool false

echo "    System defaults applied."
