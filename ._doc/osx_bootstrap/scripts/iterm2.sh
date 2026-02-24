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

# Tab position: top (0=Top, 1=Bottom, 2=Left)
defaults write com.googlecode.iterm2 TabViewType -int 0

# Minimise tab width (hidden settings)
defaults write com.googlecode.iterm2 UseUnevenTabs -bool true
defaults write com.googlecode.iterm2 MinTabWidth -int 40
defaults write com.googlecode.iterm2 MinCompactTabWidth -int 40
defaults write com.googlecode.iterm2 OptimumTabWidth -int 100

# Applications may access clipboard
defaults write com.googlecode.iterm2 AllowClipboardAccess -bool true

echo "    iTerm2 app-level defaults applied."

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

# --- Profile-level settings (direct plist manipulation) ---
# Must run AFTER all defaults write commands.
# Uses python3 because PlistBuddy can't handle keys containing colons (e.g. "base: priority").
# Flush defaults cache to disk first, then edit, then reload.

if [[ -f "$PLIST" ]]; then
  defaults read com.googlecode.iterm2 > /dev/null 2>&1  # ensure cache is flushed to disk

  python3 - "$PLIST" << 'PYEOF'
import plistlib, sys

plist_path = sys.argv[1]
with open(plist_path, "rb") as f:
    plist = plistlib.load(f)

profile = plist["New Bookmarks"][0]

# Font: JetBrains Mono Nerd Font, size 14
profile["Normal Font"] = "JetBrainsMonoNFM-Regular 14"

# Unlimited scrollback
profile["Unlimited Scrollback"] = True

# Silence bell
profile["Silence Bell"] = True

# Left Option Key = Esc+
profile["Option Key Sends"] = 2

# Cursor type: line (1=vertical bar, 2=underline, 0=box)
profile["Cursor Type"] = 1

# Background color: #1c2240
profile["Background Color"] = {
    "Red Component": 0.10980392156862745,
    "Green Component": 0.13333333333333333,
    "Blue Component": 0.25098039215686274,
    "Color Space": "sRGB",
    "Alpha Component": 1.0,
}

# Enable status bar
profile["Show Status Bar"] = True

# Status bar layout
# Key is "Status Bar Layout" with lowercase inner keys per iTerm2 source:
# https://github.com/gnachman/iTerm2/blob/master/sources/iTermStatusBarLayout.m
components = [
    "iTermStatusBarWorkingDirectoryComponent",
    "iTermStatusBarGitComponent",
]
profile["Status Bar Layout"] = {
    "advanced configuration": {
        "algorithm": 0,
        "font": ".AppleSystemUIFont 12",
        "remove empty components": False,
    },
    "components": [
        {
            "class": c,
            "configuration": {
                "knobs": {
                    "base: priority": 5.0,
                    "base: compression resistance": 1,
                },
                "layout advanced configuration dictionary value": {
                    "algorithm": 0,
                    "font": ".AppleSystemUIFont 12",
                    "remove empty components": False,
                },
            },
        }
        for c in components
    ],
}

with open(plist_path, "wb") as f:
    plistlib.dump(plist, f)
PYEOF

  # Tell cfprefsd to reload the plist from disk
  defaults read com.googlecode.iterm2 > /dev/null 2>&1

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
