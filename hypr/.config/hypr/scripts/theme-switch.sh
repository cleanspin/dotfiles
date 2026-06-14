#!/usr/bin/env bash

# Theme Switcher using Flavours
# Usage:
#   theme-switch.sh          - cycle to next theme
#   theme-switch.sh --select - use rofi to select theme
#   theme-switch.sh --set <name> - set specific theme

WALLPAPERS_DIR="$HOME/.config/wallpapers"
BTOP_CONF="$HOME/.config/btop/btop.conf"
NVIM_THEME="$HOME/.config/nvim/lua/current-theme.lua"
STARSHIP_BASE="$HOME/.config/starship-base.toml"
STARSHIP_PALETTE="$HOME/.config/starship-palette.toml"
STARSHIP_CONF="$HOME/.config/starship.toml"

# Map flavours scheme names to wallpaper directories
declare -A WALLPAPER_DIRS=(
    ["catppuccin-mocha"]="catppuccin-mocha"
    ["nord"]="nord"
    ["tokyo-night-dark"]="tokyo-night"
    ["dracula"]="dracula"
    ["gruvbox-dark-medium"]="gruvbox"
    ["rose-pine"]="rose-pine"
)

# Map flavours scheme names to btop themes
declare -A BTOP_THEMES=(
    ["catppuccin-mocha"]="catppuccin_mocha.theme"
    ["nord"]="nord.theme"
    ["tokyo-night-dark"]="tokyo-night.theme"
    ["dracula"]="dracula.theme"
    ["gruvbox-dark-medium"]="gruvbox_dark.theme"
    ["rose-pine"]="rose-pine.theme"
)

# Map flavours scheme names to neovim colorschemes
declare -A NVIM_THEMES=(
    ["catppuccin-mocha"]="catppuccin"
    ["nord"]="nord"
    ["tokyo-night-dark"]="tokyonight"
    ["dracula"]="dracula"
    ["gruvbox-dark-medium"]="gruvbox"
    ["rose-pine"]="rose-pine"
)


# Themes we want to cycle through
THEMES=("catppuccin-mocha" "nord" "tokyo-night-dark" "dracula" "gruvbox-dark-medium" "rose-pine")

get_current_theme() {
    flavours current 2>/dev/null || echo "catppuccin-mocha"
}

set_theme() {
    local theme="$1"

    # Apply with flavours
    if ! flavours apply "$theme" 2>/dev/null; then
        notify-send "Theme Error" "Theme '${theme}' not found!" -u critical
        return 1
    fi

    # Get wallpaper directory for this theme
    local wallpaper_dir="${WALLPAPER_DIRS[$theme]:-$theme}"

    # Update wallpaper if theme directory exists
    if [[ -d "$WALLPAPERS_DIR/$wallpaper_dir" ]]; then
        local wallpaper
        wallpaper=$(find "$WALLPAPERS_DIR/$wallpaper_dir" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.gif" \) | shuf -n 1)
        if [[ -n "$wallpaper" ]]; then
            awww img "$wallpaper" --transition-type grow --transition-pos 0.5,0.5 --transition-duration 2
        fi
    fi

    # Update btop theme
    local btop_theme="${BTOP_THEMES[$theme]}"
    if [[ -n "$btop_theme" && -f "$BTOP_CONF" ]]; then
        sed -i "s/^color_theme = .*/color_theme = \"$btop_theme\"/" "$BTOP_CONF"
    elif [[ -n "$btop_theme" ]]; then
        mkdir -p "$(dirname "$BTOP_CONF")"
        echo "color_theme = \"$btop_theme\"" > "$BTOP_CONF"
    fi

    # Reload kitty (if running)
    pkill -USR1 kitty 2>/dev/null

    # Update neovim theme
    local nvim_theme="${NVIM_THEMES[$theme]}"
    if [[ -n "$nvim_theme" ]]; then
        cat > "$NVIM_THEME" << EOF
-- Current theme (managed by theme-switch.sh)
vim.cmd.colorscheme("$nvim_theme")
EOF
        # Reload colorscheme in all running nvim instances
        for sock in /run/user/$UID/nvim.*.0 /tmp/nvim.*/0; do
            [[ -S "$sock" ]] && nvim --server "$sock" --remote-send "<Cmd>colorscheme $nvim_theme<CR>" 2>/dev/null
        done
    fi

    # Rebuild starship config (base + flavours-generated palette)
    if [[ -f "$STARSHIP_BASE" && -f "$STARSHIP_PALETTE" ]]; then
        /usr/bin/cat "$STARSHIP_BASE" "$STARSHIP_PALETTE" > "$STARSHIP_CONF"
    fi

    notify-send "Theme Changed" "Switched to ${theme}" -i preferences-desktop-theme
}

cycle_theme() {
    local current
    current=$(get_current_theme)
    local next_index=0

    for i in "${!THEMES[@]}"; do
        if [[ "${THEMES[$i]}" == "$current" ]]; then
            next_index=$(( (i + 1) % ${#THEMES[@]} ))
            break
        fi
    done

    set_theme "${THEMES[$next_index]}"
}

select_theme() {
    local selection
    selection=$(printf '%s\n' "${THEMES[@]}" | rofi -dmenu -p "Select Theme")
    if [[ -n "$selection" ]]; then
        set_theme "$selection"
    fi
}

case "${1:-cycle}" in
    --select|-s)
        select_theme
        ;;
    --list|-l)
        printf '%s\n' "${THEMES[@]}"
        ;;
    --set)
        set_theme "$2"
        ;;
    cycle|*)
        cycle_theme
        ;;
esac
