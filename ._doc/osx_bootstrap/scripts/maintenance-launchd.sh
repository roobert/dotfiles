#!/usr/bin/env bash
# Installs a weekly launchd job that checks for outdated tools
set -euo pipefail

CHECKER="$HOME/bin/maintenance-check.sh"
PLIST="$HOME/Library/LaunchAgents/com.user.maintenance-check.plist"

# Install launchd job - runs weekly (every 604800 seconds)
mkdir -p "$HOME/Library/LaunchAgents"
cat > "$PLIST" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.user.maintenance-check</string>
    <key>Program</key>
    <string>${CHECKER}</string>
    <key>StartInterval</key>
    <integer>604800</integer>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>${HOME}/.local/log/maintenance-check.log</string>
    <key>StandardErrorPath</key>
    <string>${HOME}/.local/log/maintenance-check.log</string>
  </dict>
</plist>
EOF

mkdir -p "$HOME/.local/log"

launchctl unload "$PLIST" 2>/dev/null || true
launchctl load -w "$PLIST"

echo "    Maintenance check scheduled (weekly)."
