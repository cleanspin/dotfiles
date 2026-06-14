#!/usr/bin/env bash

# Toggle popup windows - close if same popup is open, otherwise close others and open this one
# Usage: popup-toggle.sh <popup-name>

POPUP="$1"
POPUP_CLASSES=("weather" "bluetui" "pulsemixer")

# Check if the requested popup is already open
is_open() {
    hyprctl clients -j | jq -e ".[] | select(.class == \"$1\")" > /dev/null 2>&1
}

# Close all popup windows
close_all() {
    for class in "${POPUP_CLASSES[@]}"; do
        if is_open "$class"; then
            hyprctl dispatch closewindow "class:$class"
        fi
    done
}

# If requested popup is open, just close it (toggle off)
if is_open "$POPUP"; then
    hyprctl dispatch closewindow "class:$POPUP"
    exit 0
fi

# Close any other popups first
close_all

# Open the requested popup
case "$POPUP" in
    weather)
        hyprctl dispatch exec "[float; move (monitor_w-window_w-20) 50]" "kitty --class weather -o remember_window_size=no -o initial_window_width=70c -o initial_window_height=14c -e ~/.config/ironbar/scripts/weather-forecast.sh"
        ;;
    bluetui)
        hyprctl dispatch exec "[float; size (monitor_w*0.4) (monitor_h*0.5); move (monitor_w-window_w-20) 50]" "kitty --class bluetui bluetui"
        ;;
    pulsemixer)
        hyprctl dispatch exec "[float; size (monitor_w*0.31) (monitor_h*0.28); move (monitor_w-window_w-20) 50]" "kitty --class pulsemixer pulsemixer"
        ;;
esac
