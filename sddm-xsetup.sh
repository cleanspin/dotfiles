#!/bin/sh
# SDDM Xsetup script - configure displays before login screen
# Only enable DP-2 (left monitor), disable HDMI-A-1 (right monitor)

xrandr --output DP-2 --primary --mode 2560x1440 --rate 120 --pos 0x0
xrandr --output HDMI-A-1 --off
