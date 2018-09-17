#!/bin/sh

#xrandr --output VIRTUAL1 --off
#xrandr --output VGA1 --off
#xrandr --output DP2 --off
#xrandr --output DP1 --off
#xrandr --output HDMI3 --off



xrandr --output HDMI-1-1 --mode 1920x1080 --pos 0x0 --rotate normal --left-of DP1

xrandr --output DP-1 --mode 1920x1080 --pos 0x0 --rotate normal --right-of HDMI-1-1

xrandr --output eDP-1-1  --mode 1920x1080 --pos 0x0 --rotate normal --below DP-1

#--above eDP-1-1
#--left-of HDMI-2
