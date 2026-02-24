#!/usr/bin/env bash
# iTerm2 configuration

PLIST=~/Library/Preferences/com.googlecode.iterm2.plist

# --- App-level settings (defaults write) ---

# Theme: Minimal
defaults write com.googlecode.iterm2 TabStyleWithAutomaticOption -int 5

# Always show tab bar
defaults write com.googlecode.iterm2 HideTab -bool false

# Hide tab numbers
defaults write com.googlecode.iterm2 HideTabNumber -bool true

# Hide tab close buttons
defaults write com.googlecode.iterm2 HideTabCloseButton -bool true

# Dim inactive split panes
defaults write com.googlecode.iterm2 DimInactiveSplitPanes -bool true

# Dimming amount (~100% text dimming)
defaults write com.googlecode.iterm2 SplitPaneDimmingAmount -float 0.4

# Focus follows mouse
defaults write com.googlecode.iterm2 FocusFollowsMouse -bool true

# Status bar position: bottom
defaults write com.googlecode.iterm2 StatusBarPosition -int 1

# Separate status bar per pane
defaults write com.googlecode.iterm2 SeparateStatusBarsPerPane -bool true

# Disable per-pane titlebar
defaults write com.googlecode.iterm2 ShowPaneTitles -bool false

# Tab position: left (0=Top, 1=Bottom, 2=Left)
defaults write com.googlecode.iterm2 TabViewType -int 2

# Applications may access clipboard
defaults write com.googlecode.iterm2 AllowClipboardAccess -bool true

echo "    iTerm2 app-level defaults applied."

# --- Profile-level settings (PlistBuddy) ---
# These only work if iTerm2 has been launched at least once (plist must exist)

if [[ -f "$PLIST" ]]; then
  PB=/usr/libexec/PlistBuddy

  # Font: JetBrains Mono Nerd Font, size 14
  $PB -c "Set :'New Bookmarks':0:'Normal Font' 'JetBrainsMonoNFM-Regular 14'" "$PLIST" 2>/dev/null || true

  # Unlimited scrollback
  $PB -c "Set :'New Bookmarks':0:'Unlimited Scrollback' true" "$PLIST" 2>/dev/null || true

  # Silence bell
  $PB -c "Set :'New Bookmarks':0:'Silence Bell' true" "$PLIST" 2>/dev/null || true

  # Left Option Key = Esc+
  $PB -c "Set :'New Bookmarks':0:'Option Key Sends' 2" "$PLIST" 2>/dev/null || true

  # Enable status bar
  $PB -c "Set :'New Bookmarks':0:'Show Status Bar' true" "$PLIST" 2>/dev/null || true

  # Cursor type: line (1=vertical bar, 2=underline, 0=box)
  $PB -c "Set :'New Bookmarks':0:'Cursor Type' 1" "$PLIST" 2>/dev/null || true

  # Background color: #1c2240 (R:0.1098, G:0.1333, B:0.2510)
  $PB -c "Set :'New Bookmarks':0:'Background Color':'Red Component' 0.10980392156862745" "$PLIST" 2>/dev/null || true
  $PB -c "Set :'New Bookmarks':0:'Background Color':'Green Component' 0.13333333333333333" "$PLIST" 2>/dev/null || true
  $PB -c "Set :'New Bookmarks':0:'Background Color':'Blue Component' 0.25098039215686274" "$PLIST" 2>/dev/null || true

  echo "    iTerm2 profile settings applied."
else
  echo "    iTerm2 plist not found - launch iTerm2 once first, then re-run this script."
  echo "    Alternatively, the Dynamic Profile below will be used on next launch."
fi

# --- Dynamic Profile (works even before first launch) ---
DYNAMIC_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
mkdir -p "$DYNAMIC_DIR"

cat > "$DYNAMIC_DIR/setup-profile.json" << 'EOF'
{
  "Profiles": [
    {
      "Name": "Default",
      "Guid": "setup-default-profile",
      "Dynamic Profile Parent Name": "Default",
      "Normal Font": "JetBrainsMonoNFM-Regular 14",
      "Unlimited Scrollback": true,
      "Silence Bell": true,
      "Option Key Sends": 2,
      "Show Status Bar": true,
      "Cursor Type": 1,
      "Background Color": {
        "Red Component": 0.10980392156862745,
        "Green Component": 0.13333333333333333,
        "Blue Component": 0.25098039215686274,
        "Color Space": "sRGB"
      }
    }
  ]
}
EOF

echo "    iTerm2 Dynamic Profile installed."

# --- Keybindings ---
# Uses -dict-add to preserve existing bindings
# Key format: 0xKEYCODE-0xMODIFIERS (modifiers: Shift=0x20000, Ctrl=0x40000, Opt=0x80000, Cmd=0x100000)
# Action codes: https://github.com/gnachman/iTerm2/blob/master/sources/iTermKeyBindingAction.h

# Scroll: Shift+PageDn / Cmd+PageDn = Page Down (8)
defaults write com.googlecode.iterm2 GlobalKeyMap -dict-add "0xf72d-0x20000" '<dict><key>Action</key><integer>8</integer><key>Text</key><string></string></dict>'
defaults write com.googlecode.iterm2 GlobalKeyMap -dict-add "0xf72d-0x100000" '<dict><key>Action</key><integer>8</integer><key>Text</key><string></string></dict>'
# Scroll: Shift+PageUp / Cmd+PageUp = Page Up (9)
defaults write com.googlecode.iterm2 GlobalKeyMap -dict-add "0xf72c-0x20000" '<dict><key>Action</key><integer>9</integer><key>Text</key><string></string></dict>'
defaults write com.googlecode.iterm2 GlobalKeyMap -dict-add "0xf72c-0x100000" '<dict><key>Action</key><integer>9</integer><key>Text</key><string></string></dict>'
# Scroll: Cmd+End = Scroll to End (4), Cmd+Home = Scroll to Top (5)
defaults write com.googlecode.iterm2 GlobalKeyMap -dict-add "0xf72b-0x100000" '<dict><key>Action</key><integer>4</integer><key>Text</key><string></string></dict>'
defaults write com.googlecode.iterm2 GlobalKeyMap -dict-add "0xf729-0x100000" '<dict><key>Action</key><integer>5</integer><key>Text</key><string></string></dict>'

# Split: Ctrl+X = Split Vertically (29), Ctrl+Shift+X = Split Horizontally (28)
defaults write com.googlecode.iterm2 GlobalKeyMap -dict-add "0x78-0x40000" '<dict><key>Action</key><integer>29</integer><key>Text</key><string></string></dict>'
defaults write com.googlecode.iterm2 GlobalKeyMap -dict-add "0x58-0x60000" '<dict><key>Action</key><integer>28</integer><key>Text</key><string></string></dict>'

# Tabs: Ctrl+Tab = Next Tab (0), Ctrl+Shift+Tab = Previous Tab (2)
defaults write com.googlecode.iterm2 GlobalKeyMap -dict-add "0x9-0x40000" '<dict><key>Action</key><integer>0</integer><key>Text</key><string></string></dict>'
defaults write com.googlecode.iterm2 GlobalKeyMap -dict-add "0x9-0x60000" '<dict><key>Action</key><integer>2</integer><key>Text</key><string></string></dict>'

# Panes: Ctrl+` = Next Pane (30), Ctrl+Shift+` = Previous Pane (31)
defaults write com.googlecode.iterm2 GlobalKeyMap -dict-add "0x60-0x40000" '<dict><key>Action</key><integer>30</integer><key>Text</key><string></string></dict>'
defaults write com.googlecode.iterm2 GlobalKeyMap -dict-add "0x60-0x60000" '<dict><key>Action</key><integer>31</integer><key>Text</key><string></string></dict>'

echo "    iTerm2 keybindings applied."
