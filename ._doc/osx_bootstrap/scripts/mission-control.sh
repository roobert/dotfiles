#!/usr/bin/env bash
# Mission Control: bind Ctrl+1..9 to switch desktops
#
# Hotkey IDs 118-126 = Switch to Desktop 1-9
# Parameter tuple: (65535, <virtual_keycode>, 262144)
#   65535 = no ASCII char, 262144 = Control modifier
#
# Virtual key codes for number keys:
#   1=18, 2=19, 3=20, 4=21, 5=23, 6=22, 7=26, 8=28, 9=25

declare -A DESKTOP_KEYS=(
  [118]=18  # Desktop 1
  [119]=19  # Desktop 2
  [120]=20  # Desktop 3
  [121]=21  # Desktop 4
  [122]=23  # Desktop 5
  [123]=22  # Desktop 6
  [124]=26  # Desktop 7
  [125]=28  # Desktop 8
  [126]=25  # Desktop 9
)

for hotkey_id in "${!DESKTOP_KEYS[@]}"; do
  keycode="${DESKTOP_KEYS[$hotkey_id]}"
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$hotkey_id" \
    "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>${keycode}</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"
done

# Apply changes without logout
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

echo "    Mission Control Ctrl+1..9 bindings applied."
echo "    Note: the desktops must already exist in Mission Control for shortcuts to work."
