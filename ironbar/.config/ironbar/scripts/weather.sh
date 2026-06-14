#!/bin/bash

# Weather wrapper for ironbar — outputs Pango markup with BMP PUA icons.
# GTK4 can't render Supplementary PUA (4-byte) Nerd Font icons, so we
# replace them with BMP PUA alternatives (U+F000-F8FF).
#
# Pango markup OVERRIDES CSS in ironbar/GTK4, and the bar's global
# `* { color: @base05 }` (light) would otherwise wash this text out on the
# bright weather pill. So we inline the active theme's dark bg (base00),
# read from flavours' generated colors.css, for dark-on-bright legibility
# that still follows the theme.

C=$(grep -m1 'base00' ~/.config/ironbar/colors.css 2>/dev/null | grep -oE '#[0-9a-fA-F]{6}')
C=${C:-#1e1e2e}

output=$(~/.config/ironbar/scripts/weather-data.sh 2>/dev/null)

if [[ -z "$output" ]]; then
    printf '<span color="%s"><span font="FiraCode Nerd Font"></span> <span font="Google Sans">--°</span></span>' "$C"
    exit 0
fi

echo "$output" | C="$C" python3 -c "
import sys, json, os

color = os.environ.get('C', '#1e1e2e')
data = json.load(sys.stdin)
text = data.get('text', '')

icon_map = {
    '\U000F0599': '',  # clear/sunny -> fa-sun-o
    '\U000F0590': '',  # partly cloudy -> fa-cloud
    '\U000F0591': '',  # fog -> fa-cloud
    '\U000F0597': '',  # drizzle -> fa-tint
    '\U000F065F': '',  # freezing drizzle -> fa-tint
    '\U000F0596': '',  # rain -> fa-tint
    '\U000F0F36': '',  # snow -> fa-snowflake
    '\U000F0593': '',  # thunderstorm -> fa-bolt
    '\U000F0F2F': '',  # unknown/error -> fa-sun-o
}

result = []
for ch in text:
    if ord(ch) > 0xFFFF:
        result.append(icon_map.get(ch, ''))
    else:
        result.append(ch)

clean = ''.join(result)

parts = clean.split(' ', 1)
if len(parts) == 2:
    icon, temp = parts
    print(f'<span color=\"{color}\"><span font=\"FiraCode Nerd Font\">{icon}</span> <span font=\"Google Sans\">{temp}</span></span>', end='')
else:
    print(f'<span color=\"{color}\" font=\"Google Sans\">{clean}</span>', end='')
"
