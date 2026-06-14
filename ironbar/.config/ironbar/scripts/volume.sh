#!/bin/bash

# Volume display for ironbar - matches the old waybar pulseaudio format
# Shows only sink (output) volume, not source (mic)
#
# Pango markup OVERRIDES CSS for both color and font in ironbar/GTK4 — the
# bar's global `* { color: @base05 }` (light) wins over per-module CSS, so
# text on the bright pills must carry its color inline. We read the active
# theme's dark bg (base00) from flavours' generated colors.css so the text
# stays dark-on-bright AND follows the theme.

vol=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -oP '\d+%' | head -1 | tr -d '%')
mute=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | grep -oP 'yes|no')

# Pill text color = theme base00 (dark); fall back to a sane dark if unreadable.
C=$(grep -m1 'base00' ~/.config/ironbar/colors.css 2>/dev/null | grep -oE '#[0-9a-fA-F]{6}')
C=${C:-#1e1e2e}
F='Google Sans'

if [[ "$mute" == "yes" ]]; then
    printf '<span color="%s"><span font="FiraCode Nerd Font"></span>  <span font="%s">Muted</span></span>' "$C" "$F"
elif [[ "$vol" -ge 66 ]]; then
    printf '<span color="%s"><span font="FiraCode Nerd Font"></span>  <span font="%s">%s%%</span></span>' "$C" "$F" "$vol"
elif [[ "$vol" -ge 33 ]]; then
    printf '<span color="%s"><span font="FiraCode Nerd Font"></span>  <span font="%s">%s%%</span></span>' "$C" "$F" "$vol"
else
    printf '<span color="%s"><span font="FiraCode Nerd Font"></span>  <span font="%s">%s%%</span></span>' "$C" "$F" "$vol"
fi
