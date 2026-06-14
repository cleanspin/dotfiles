#!/bin/bash

# Power menu options - icon + label
options="󰌾 Lock\n󰤄 Sleep\n󰍃 Logout\n󰜉 Reboot\n⏻ Shutdown"

chosen=$(echo -e "$options" | ~/.config/rofi/scripts/rofi-toggle.sh -dmenu -theme ~/.config/rofi/powermenu.rasi)

case "$chosen" in
    *"Lock"*) hyprlock ;;
    *"Sleep"*) systemctl suspend ;;
    *"Logout"*) hyprctl dispatch exit ;;
    *"Reboot"*) systemctl reboot ;;
    *"Shutdown"*) systemctl poweroff ;;
esac
