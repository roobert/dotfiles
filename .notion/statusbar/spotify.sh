#!/usr/bin/env bash

METADATA="$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata')"

TITLE="$(echo $METADATA  | sed 's/.*"xesam:title" variant string "\([^"]*\).*/\1/')"
ARTIST="$(echo $METADATA | sed 's/.*"xesam:artist" variant array \[ string "\([^"]*\).*/\1/')"
ALBUM="$(echo $METADATA  | sed 's/.*"xesam:album" variant string "\([^"]*\).*/\1/')"

echo -n " | $ARTIST - $ALBUM - $TITLE"
