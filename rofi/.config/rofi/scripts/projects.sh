#!/bin/bash

PROJECTS_DIR="$HOME/Projects"

# Company internal links
declare -A COMPANY_LINKS=(
    ["Projects"]="https://projects.compassrose.systems"
    ["Files"]="https://files.compassrose.systems"
    ["Traefik"]="https://traefik.compassrose.systems"
    ["Auth"]="https://auth.compassrose.systems"
    ["Portainer"]="https://portainer.compassrose.systems"
    ["Marine Matcher"]="https://marine-matcher.compassrose.systems"
)

case "$1" in
    --claude)
        if [[ -z "$2" ]]; then
            find "$PROJECTS_DIR" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | sort
        else
            setsid kitty --single-instance -o new_os_window=yes --directory "$PROJECTS_DIR/$2" -e claude >/dev/null 2>&1 &
            disown
        fi
        ;;
    --cursor)
        if [[ -z "$2" ]]; then
            find "$PROJECTS_DIR" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | sort
        else
            setsid cursor "$PROJECTS_DIR/$2" >/dev/null 2>&1 &
            disown
        fi
        ;;
    --company)
        if [[ -z "$2" ]]; then
            printf '%s\n' "${!COMPANY_LINKS[@]}" | sort
        else
            setsid xdg-open "${COMPANY_LINKS[$2]}" >/dev/null 2>&1 &
            disown
        fi
        ;;
    --terminal)
        if [[ -z "$2" ]]; then
            find "$PROJECTS_DIR" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | sort
        else
            setsid kitty --single-instance -o new_os_window=yes --directory "$PROJECTS_DIR/$2" >/dev/null 2>&1 &
            disown
        fi
        ;;
    *)
        echo "Usage: $0 {--claude|--cursor|--company|--terminal} [selection]"
        ;;
esac
