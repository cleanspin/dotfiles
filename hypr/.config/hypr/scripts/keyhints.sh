#!/usr/bin/env bash
# Keybindings cheat sheet using yad

# Kill existing instances
pkill -x yad 2>/dev/null

# Launch yad cheat sheet
GDK_BACKEND=wayland yad \
    --center \
    --title="Keybindings Cheat Sheet" \
    --no-buttons \
    --list \
    --column="Key" \
    --column="Action" \
    --timeout=60 \
    --timeout-indicator=bottom \
    --width=500 \
    --height=600 \
"" "── APPS ──" \
"SUPER + Return" "Terminal (kitty)" \
"SUPER + Space" "App Launcher (rofi)" \
"SUPER + E" "File Manager (yazi)" \
"SUPER + O" "File Search (rofi)" \
"SUPER + C" "Projects Launcher" \
"" "" \
"" "── WINDOWS ──" \
"SUPER + Q" "Close Window" \
"SUPER + F" "Fullscreen" \
"SUPER + V" "Toggle Floating" \
"SUPER + P" "Float + Resize (preset)" \
"SUPER + J" "Toggle Split" \
"ALT + Tab" "Cycle Workspaces" \
"ALT + Shift + Tab" "Cycle Workspaces (reverse)" \
"" "" \
"" "── FOCUS (Arrow Keys or HJKL) ──" \
"SUPER + ←↓↑→" "Move Focus" \
"SUPER + H/J/K/L" "Move Focus (vim)" \
"" "" \
"" "── WORKSPACES ──" \
"SUPER + 1-0" "Switch Workspace" \
"SUPER + Shift + 1-0" "Move Window to Workspace" \
"SUPER + Scroll" "Cycle Workspaces" \
"" "" \
"" "── MOUSE ──" \
"SUPER + Drag" "Move Window" \
"SUPER + Right-Drag" "Resize Window" \
"" "" \
"" "── SCREENSHOTS ──" \
"Print" "Screenshot Region → Clipboard" \
"Shift + Print" "Full Screen → Clipboard" \
"SUPER + Print" "Screenshot Region → File" \
"" "" \
"" "── SYSTEM ──" \
"SUPER + X" "Power Menu" \
"SUPER + Shift + L" "Lock Screen" \
"SUPER + W" "Wallpaper Picker" \
"SUPER + Shift + T" "Theme Switch" \
"SUPER + M" "Exit Hyprland" \
"SUPER + /" "This Cheat Sheet"
