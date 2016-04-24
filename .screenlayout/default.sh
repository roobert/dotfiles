#!/bin/sh

xrandr --output eDP1  --mode 2880x1800 --pos 0x0 --rotate normal --right-of DP1  --left-of DP2
#xrandr --output eDP1  --mode 1920x1200 --pos 0x0 --rotate normal --right-of DP1  --left-of DP2
xrandr --output DP1   --mode 2048x1536 --pos 0x0 --rotate normal --left-of  eDP1 --scale 0.5x0.5
xrandr --output DP2   --mode 2048x1536 --pos 0x0 --rotate normal --right-of eDP1 --scale 0.5x0.5
