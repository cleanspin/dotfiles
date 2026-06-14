#!/bin/bash

# Get current theme from flavours
CURRENT_SCHEME=$(flavours current 2>/dev/null || echo "catppuccin-mocha")

# Map flavours scheme names to wallpaper directories
declare -A WALLPAPER_DIRS=(
    ["catppuccin-mocha"]="catppuccin-mocha"
    ["nord"]="nord"
    ["tokyo-night-dark"]="tokyo-night"
    ["dracula"]="dracula"
    ["gruvbox-dark-medium"]="gruvbox"
    ["rose-pine"]="rose-pine"
)

CURRENT_THEME="${WALLPAPER_DIRS[$CURRENT_SCHEME]:-$CURRENT_SCHEME}"
WALLPAPERS_DIR="$HOME/.config/wallpapers/$CURRENT_THEME"
CACHE_DIR="$HOME/.cache/wallpaper-thumbs/$CURRENT_THEME"

# Create cache dir if needed
mkdir -p "$CACHE_DIR"

# Generate thumbnails if missing
generate_thumbs() {
    find "$WALLPAPERS_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" \) | while read -r img; do
        filename=$(basename "$img")
        thumb="$CACHE_DIR/$filename"
        if [[ ! -f "$thumb" ]] || [[ "$img" -nt "$thumb" ]]; then
            convert "$img" -resize 300x200^ -gravity center -extent 300x200 "$thumb" 2>/dev/null
        fi
    done
}

if [[ -z "$1" ]]; then
    generate_thumbs
    # List wallpapers with icon path
    find "$WALLPAPERS_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" \) | sort | while read -r img; do
        filename=$(basename "$img")
        thumb="$CACHE_DIR/$filename"
        name="${filename%.*}"
        # Format: name\0icon\x1fpath
        echo -en "${name}\0icon\x1f${thumb}\n"
    done
else
    # Set selected wallpaper
    for ext in jpg png; do
        wallpaper="$WALLPAPERS_DIR/$1.$ext"
        if [[ -f "$wallpaper" ]]; then
            awww img "$wallpaper" --transition-type grow --transition-pos 0.5,0.5 --transition-duration 2
            notify-send "Wallpaper Changed" "$1" -i preferences-desktop-wallpaper
            exit 0
        fi
    done
fi
