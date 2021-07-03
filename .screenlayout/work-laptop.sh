#!/bin/sh

xrandr --output HDMI-1-1 --mode 1920x1080 --pos 0x0 --rotate normal --left-of DP1
xrandr --output DP-1 --mode 1920x1080 --pos 0x0 --rotate normal --right-of HDMI-1-1
xrandr --output eDP-1-1  --mode 1920x1080 --pos 0x0 --rotate normal --below DP-1
