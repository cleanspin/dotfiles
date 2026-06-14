#!/usr/bin/env bash

# Rofi File Browser - Native rofi script mode with multiple modi
# Usage: rofi -modi "Curated:script --curated,Home:script --home,Global:script --global" -show Curated

MODE="$1"

CURATED_DIRS=(
    "$HOME/Projects"
    "$HOME/Documents"
    "$HOME/Downloads"
    "$HOME/.config"
    "$HOME/Pictures"
)

EXCLUDES=(
    "node_modules"
    ".git"
    ".cache"
    "__pycache__"
    "target"
    "dist"
    "build"
    ".npm"
    ".cargo"
    ".local/share"
    ".mozilla"
    ".steam"
)

EXCLUDE_ARGS=()
for exc in "${EXCLUDES[@]}"; do
    EXCLUDE_ARGS+=("--exclude" "$exc")
done

# If second argument exists, it's a selection
if [[ -n "$2" ]]; then
    selected="$2"

    # Convert ~ back to $HOME
    selected="${selected/#\~/$HOME}"

    if [[ "$selected" == */ ]]; then
        # Directory - open terminal there
        selected="${selected%/}"
        coproc (kitty --single-instance -o new_os_window=yes --directory "$selected" &)
    elif [[ -f "$selected" ]]; then
        mime=$(file --mime-type -b "$selected")

        if [[ "$mime" == text/* || "$mime" == application/json || "$mime" == application/javascript || "$mime" == application/x-shellscript ]]; then
            coproc (kitty --single-instance -o new_os_window=yes -e nvim "$selected" &)
        else
            coproc (xdg-open "$selected" &>/dev/null &)
        fi
    fi
    exit 0
fi

# Output file list based on mode
case "$MODE" in
    --curated)
        for dir in "${CURATED_DIRS[@]}"; do
            if [[ -d "$dir" ]]; then
                fd --type d --hidden "${EXCLUDE_ARGS[@]}" . "$dir" 2>/dev/null | sed "s|$HOME|~|;s|$|/|"
                fd --type f --hidden "${EXCLUDE_ARGS[@]}" . "$dir" 2>/dev/null | sed "s|$HOME|~|"
            fi
        done
        ;;
    --home)
        fd --type d --hidden "${EXCLUDE_ARGS[@]}" --max-depth 5 . "$HOME" 2>/dev/null | sed "s|$HOME|~|;s|$|/|"
        fd --type f --hidden "${EXCLUDE_ARGS[@]}" --max-depth 5 . "$HOME" 2>/dev/null | sed "s|$HOME|~|"
        ;;
    --global)
        fd --type d "${EXCLUDE_ARGS[@]}" --max-depth 4 . / 2>/dev/null | sed 's|$|/|'
        fd --type f "${EXCLUDE_ARGS[@]}" --max-depth 4 . / 2>/dev/null
        ;;
esac
