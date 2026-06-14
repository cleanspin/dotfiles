#!/bin/bash

# Toggle floating with preset size and off-center position (monitor-aware)

WINDOW_INFO=$(hyprctl activewindow -j)
IS_FLOATING=$(echo "$WINDOW_INFO" | jq -r '.floating')
MONITOR=$(echo "$WINDOW_INFO" | jq -r '.monitor')

# Get monitor info
MONITOR_INFO=$(hyprctl monitors -j | jq -r ".[] | select(.id == $MONITOR)")
MON_X=$(echo "$MONITOR_INFO" | jq -r '.x')
MON_Y=$(echo "$MONITOR_INFO" | jq -r '.y')
MON_W=$(echo "$MONITOR_INFO" | jq -r '.width')
MON_H=$(echo "$MONITOR_INFO" | jq -r '.height')

# Size/position as percentage of monitor (based on workspace 4 terminal on 2560x1440)
# 1812/2560 = 70.8%, 885/1440 = 61.5%, 662/2560 = 25.9%, 159/1440 = 11%
WIDTH=$((MON_W * 708 / 1000))
HEIGHT=$((MON_H * 615 / 1000))
REL_X=$((MON_W * 259 / 1000))
REL_Y=$((MON_H * 11 / 100))

if [ "$IS_FLOATING" = "true" ]; then
    # Return to tiled
    hyprctl dispatch togglefloating
else
    # Float, resize and position relative to current monitor
    hyprctl dispatch togglefloating
    hyprctl dispatch resizeactive exact $WIDTH $HEIGHT
    hyprctl dispatch moveactive exact $((MON_X + REL_X)) $((MON_Y + REL_Y))
fi
