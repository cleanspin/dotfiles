#!/usr/bin/env bash

# Rofi Toggle - kills rofi if running, otherwise launches it
# Usage: rofi-toggle.sh [rofi arguments...]

if pgrep -x rofi > /dev/null; then
    pkill -x rofi
else
    rofi "$@"
fi
