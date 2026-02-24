#!/usr/bin/env bash
# Keyboard remapping:
#   § <-> ` (for non-US keyboards)
#   Caps Lock <-> Escape

MAPPING='{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064},{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035},{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029},{"HIDKeyboardModifierMappingSrc":0x700000029,"HIDKeyboardModifierMappingDst":0x700000039}]}'

# Apply immediately
hidutil property --set "$MAPPING"

# Create the script that runs at login
cat > ~/.key-remap << EOF
#!/usr/bin/env bash
hidutil property --set '$MAPPING'
EOF
chmod +x ~/.key-remap

# Install LaunchAgent (runs in user session, not as root)
PLIST="$HOME/Library/LaunchAgents/org.custom.key-remap.plist"
mkdir -p "$HOME/Library/LaunchAgents"
cat > "$PLIST" << PLISTEOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.custom.key-remap</string>
    <key>Program</key>
    <string>${HOME}/.key-remap</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
  </dict>
</plist>
PLISTEOF

# Remove old tilde-switch agent if it exists
launchctl bootout "gui/$(id -u)" "$HOME/Library/LaunchAgents/org.custom.tilde-switch.plist" 2>/dev/null || true
rm -f "$HOME/Library/LaunchAgents/org.custom.tilde-switch.plist" "$HOME/.tilde-switch"

launchctl bootout "gui/$(id -u)" "$PLIST" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PLIST"

echo "    Keyboard remapping configured (§/\` swap + Caps Lock/Escape swap)."
