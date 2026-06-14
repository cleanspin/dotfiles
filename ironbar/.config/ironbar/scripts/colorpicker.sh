#!/usr/bin/env bash

# Color picker for ironbar
# Left-click: pick color in hex format
# Right-click: pick color in rgb format

pick_color() {
    local format="$1"
    local color

    if [[ "$format" == "rgb" ]]; then
        color=$(hyprpicker -a -f rgb 2>/dev/null)
    else
        color=$(hyprpicker -a -f hex 2>/dev/null)
    fi

    [[ -n "$color" ]] && notify-send "Color Picked" "$color" -t 2000
}

if [[ "$1" == "pick-hex" ]]; then
    pick_color "hex"
elif [[ "$1" == "pick-rgb" ]]; then
    pick_color "rgb"
else
    printf '{"text": "\uf1fb", "tooltip": "Left: hex | Right: rgb"}\n'
fi
