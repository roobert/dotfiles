#!/usr/bin/env bash
# iTerm2 configuration

PLIST=~/Library/Preferences/com.googlecode.iterm2.plist

# --- macOS Sequoia: disable window tiling interference ---
# Frees up modifier keys (Cmd+Shift+Option) that macOS intercepts for edge-drag tiling
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false
echo "    macOS window tiling disabled."

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

# Dimming amount (0.2 = subtle inactive fade)
defaults write com.googlecode.iterm2 SplitPaneDimmingAmount -float 0.2

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

# Hide window number (⌥⌘N) hint in title bar
defaults write com.googlecode.iterm2 WindowNumber -bool false

# Applications may access clipboard
defaults write com.googlecode.iterm2 AllowClipboardAccess -bool true

# Enable Python API (used by Claude Code hooks to set status bar variables)
defaults write com.googlecode.iterm2 EnableAPIServer -bool true

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

# Foreground color: #1c1c1c (near-black)
_fg = {
    "Red Component": 0.10980392156862745,
    "Green Component": 0.10980392156862745,
    "Blue Component": 0.10980392156862745,
    "Color Space": "sRGB",
    "Alpha Component": 1.0,
}
profile["Foreground Color"] = dict(_fg)
profile["Foreground Color (Light)"] = dict(_fg)
profile["Foreground Color (Dark)"] = dict(_fg)

# Background color: #e0e0e0 (light gray)
_bg = {
    "Red Component": 0.8784313725490196,
    "Green Component": 0.8784313725490196,
    "Blue Component": 0.8784313725490196,
    "Color Space": "sRGB",
    "Alpha Component": 1.0,
}
profile["Background Color"] = dict(_bg)
profile["Background Color (Light)"] = dict(_bg)
profile["Background Color (Dark)"] = dict(_bg)

# Ansi 7 (white/light gray): #999999 — better contrast against light background
_ansi7 = {
    "Red Component": 0.6,
    "Green Component": 0.6,
    "Blue Component": 0.6,
    "Color Space": "sRGB",
    "Alpha Component": 1.0,
}
profile["Ansi 7 Color"] = dict(_ansi7)

# Ansi 8 (bright black/dim gray): #4a4a4a — darker for visibility
_ansi8 = {
    "Red Component": 0.2901960784313726,
    "Green Component": 0.2901960784313726,
    "Blue Component": 0.2901960784313726,
    "Color Space": "sRGB",
    "Alpha Component": 1.0,
}
profile["Ansi 8 Color"] = dict(_ansi8)

# Enable status bar
profile["Show Status Bar"] = True

# Status bar layout
# Key is "Status Bar Layout" with lowercase inner keys per iTerm2 source:
# https://github.com/gnachman/iTerm2/blob/master/sources/iTermStatusBarLayout.m
layout_cfg = {
    "algorithm": 1,
    "font": ".AppleSystemUIFont 12",
    "remove empty components": False,
}

def make_component(cls, extra_knobs=None):
    knobs = {"base: priority": 5.0, "base: compression resistance": 1}
    if extra_knobs:
        knobs.update(extra_knobs)
    return {
        "class": cls,
        "configuration": {
            "knobs": knobs,
            "layout advanced configuration dictionary value": dict(layout_cfg),
        },
    }

profile["Status Bar Layout"] = {
    "advanced configuration": dict(layout_cfg),
    "components": [
        make_component("iTermStatusBarWorkingDirectoryComponent"),
        make_component("iTermStatusBarGitComponent"),
        make_component(
            "iTermStatusBarSwiftyStringComponent",
            {"expression": "\\(user.claude_session)"},
        ),
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
      "Foreground Color": {
        "Red Component": 0.10980392156862745,
        "Green Component": 0.10980392156862745,
        "Blue Component": 0.10980392156862745,
        "Color Space": "sRGB"
      },
      "Background Color": {
        "Red Component": 0.8784313725490196,
        "Green Component": 0.8784313725490196,
        "Blue Component": 0.8784313725490196,
        "Color Space": "sRGB"
      },
      "Ansi 7 Color": {
        "Red Component": 0.6,
        "Green Component": 0.6,
        "Blue Component": 0.6,
        "Color Space": "sRGB"
      },
      "Ansi 8 Color": {
        "Red Component": 0.2901960784313726,
        "Green Component": 0.2901960784313726,
        "Blue Component": 0.2901960784313726,
        "Color Space": "sRGB"
      }
    }
  ]
}
EOF

echo "    iTerm2 Dynamic Profile installed."
