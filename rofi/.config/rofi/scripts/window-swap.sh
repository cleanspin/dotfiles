#!/bin/bash

# Get currently focused window
FOCUSED_ADDR=$(hyprctl activewindow -j | jq -r '.address')

# Get all windows except the focused one
WINDOWS=$(hyprctl clients -j | jq -r --arg focused "$FOCUSED_ADDR" '.[] | select(.address != $focused) | "\(.address)|\(.class)|\(.title[0:40])"')

if [ -z "$WINDOWS" ]; then
    notify-send "Window Swap" "No other windows to swap with"
    exit 0
fi

# Format for rofi display (class - title) and keep addresses
DISPLAY_LIST=""
ADDR_LIST=""
while IFS='|' read -r addr class title; do
    DISPLAY_LIST+="$class - $title\n"
    ADDR_LIST+="$addr\n"
done <<< "$WINDOWS"

# Remove trailing newline
DISPLAY_LIST=$(echo -e "$DISPLAY_LIST" | sed '/^$/d')
ADDR_LIST=$(echo -e "$ADDR_LIST" | sed '/^$/d')

# Show rofi and get selection
SELECTED=$(echo -e "$DISPLAY_LIST" | rofi -dmenu -i -theme ~/.config/rofi/window-swap.rasi -p "Swap with")

if [ -z "$SELECTED" ]; then
    exit 0
fi

# Find the selected window's address
LINE_NUM=$(echo -e "$DISPLAY_LIST" | grep -n "^${SELECTED}$" | head -1 | cut -d: -f1)
TARGET_ADDR=$(echo -e "$ADDR_LIST" | sed -n "${LINE_NUM}p")

# Swap windows
hyprctl dispatch swapwindow address:$TARGET_ADDR
