#!/usr/bin/env bash
# Creates an aggregate audio device combining MacBook Pro Speakers + Logitech
# Brio 500 webcam mic. Writes directly to the CoreAudio SystemSettings plist.
# Requires sudo. Idempotent.

PLIST="/Library/Preferences/Audio/com.apple.audio.SystemSettings.plist"
AGGREGATE_UID="~:AMS2_Aggregate:0"
AGGREGATE_NAME="Aggregate Device"

sudo python3 << 'PYEOF'
import plistlib
import sys

path = "/Library/Preferences/Audio/com.apple.audio.SystemSettings.plist"
uid = "~:AMS2_Aggregate:0"
name = "Aggregate Device"

subdevices = [
    {
        "channels-in": 2,
        "channels-out": 0,
        "don't pad": 0,
        "drift": 0,
        "drift algorithm": 0,
        "drift quality": 127,
        "latency-in": 0,
        "latency-out": 0,
        "name": "Brio 500",
        "uid": "AppleUSBAudioEngine:Unknown Manufacturer:Brio 500:2431ZBE1QKD8:3",
    },
    {
        "channels-in": 6,
        "channels-out": 2,
        "don't pad": 0,
        "drift": 1,
        "drift algorithm": 0,
        "drift quality": 127,
        "latency-in": 0,
        "latency-out": 0,
        "name": "MacBook Pro Speakers",
        "uid": "BuiltInSpeakerDevice",
    },
]

with open(path, "rb") as f:
    data = plistlib.load(f)

meta_key = f"MetaDevice.{uid}"

# Check if aggregate already exists with correct subdevices
existing = data.get(meta_key, {}).get("subdevices", [])
existing_uids = {d.get("uid") for d in existing if isinstance(d, dict)}
wanted_uids = {d["uid"] for d in subdevices}
if existing_uids == wanted_uids:
    print("    Aggregate device already configured, skipping.")
    sys.exit(0)

# Create or update the aggregate device
if "Meta_UIDList" not in data:
    data["Meta_UIDList"] = []
if uid not in data["Meta_UIDList"]:
    data["Meta_UIDList"].append(uid)

data[meta_key] = {
    "name": name,
    "subdevices": subdevices,
    "uid": uid,
}

with open(path, "wb") as f:
    plistlib.dump(data, f)

print("    Aggregate device configured: " + name)
for d in subdevices:
    print(f"    - {d['name']} ({d['uid']})")
PYEOF
