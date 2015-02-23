#!/bin/sh

#xrandr --output VIRTUAL1 --off
#xrandr --output VGA1 --off
#xrandr --output DP2 --off
#xrandr --output DP1 --off
#xrandr --output HDMI3 --off

xrandr --output HDMI2 --mode 1920x1080 --pos 0x0 --rotate normal
xrandr --output eDP1  --mode 1920x1080 --pos 0x0 --rotate normal --below HDMI2
xrandr --output HDMI1 --mode 1920x1080 --pos 0x0 --rotate normal --left-of HDMI2
