#!/usr/bin/env bash
# Swap § and ` keys (for non-US keyboards)

# Apply immediately
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064},{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035}]}'

# Create the script that runs at boot
cat << 'SCRIPT' > ~/.tilde-switch
#!/usr/bin/env bash
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064},{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035}]}'
SCRIPT
chmod +x ~/.tilde-switch

# Install LaunchDaemon (requires sudo)
sudo tee /Library/LaunchDaemons/org.custom.tilde-switch.plist > /dev/null << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.custom.tilde-switch</string>
    <key>Program</key>
    <string>${HOME}/.tilde-switch</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
  </dict>
</plist>
EOF

sudo launchctl load -w /Library/LaunchDaemons/org.custom.tilde-switch.plist 2>/dev/null || true

echo "    Keyboard swap configured."
