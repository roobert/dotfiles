#!/usr/bin/env bash
# Configure hostname and timezone

# Hostname
current_hostname=$(scutil --get ComputerName 2>/dev/null || hostname)
read -p "==> Hostname [mbp0]: " hostname
hostname="${hostname:-mbp0}"
if [[ "$hostname" != "$current_hostname" ]]; then
  sudo scutil --set ComputerName "$hostname"
  sudo scutil --set HostName "$hostname"
  sudo scutil --set LocalHostName "$hostname"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$hostname"
  echo "    Hostname set to $hostname."
else
  echo "    Hostname already $hostname."
fi

# Timezone
current_tz=$(sudo systemsetup -gettimezone 2>/dev/null | awk -F': ' '{print $2}' || echo "unknown")
read -p "==> Timezone [Europe/London]: " timezone
timezone="${timezone:-Europe/London}"
if [[ "$timezone" != "$current_tz" ]]; then
  sudo systemsetup -settimezone "$timezone"
  echo "    Timezone set to $timezone."
else
  echo "    Timezone already $timezone."
fi
