#!/bin/bash

# Bluetooth manager for rofi

power_status() {
    bluetoothctl show | grep -q "Powered: yes" && echo "on" || echo "off"
}

# No argument - show menu
if [[ -z "$1" ]]; then
    if [[ "$(power_status)" == "off" ]]; then
        echo "󰂲  Bluetooth Off - Click to enable"
        exit 0
    fi

    echo "󰂰  Scan for devices"
    echo "󰂲  Power Off"
    echo "---"

    # List paired devices
    bluetoothctl devices Paired | while read -r _ mac name; do
        if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
            echo "󰂱  $name (connected)"
        else
            echo "󰂯  $name"
        fi
    done
else
    selection="$1"

    case "$selection" in
        "󰂲  Bluetooth Off - Click to enable")
            bluetoothctl power on
            notify-send "Bluetooth" "Powered on" -i bluetooth
            ;;
        "󰂲  Power Off")
            bluetoothctl power off
            notify-send "Bluetooth" "Powered off" -i bluetooth
            ;;
        "󰂰  Scan for devices")
            notify-send "Bluetooth" "Scanning for 5 seconds..." -i bluetooth
            bluetoothctl --timeout 5 scan on &>/dev/null
            # Show new devices
            paired=$(bluetoothctl devices Paired | awk '{print $2}')
            bluetoothctl devices | while read -r _ mac name; do
                if ! echo "$paired" | grep -q "$mac"; then
                    echo "󰂲  $name (new)"
                fi
            done
            ;;
        "---")
            exit 0
            ;;
        *)
            # Extract device name (remove icon prefix and status suffix)
            name=$(echo "$selection" | sed 's/^[^ ]* *//' | sed 's/ (connected)$//' | sed 's/ (new)$//')

            # Find MAC by name
            mac=$(bluetoothctl devices | grep "$name" | awk '{print $2}')

            if [[ -z "$mac" ]]; then
                notify-send "Bluetooth" "Device not found" -i bluetooth
                exit 1
            fi

            if echo "$selection" | grep -q "(connected)"; then
                bluetoothctl disconnect "$mac"
                notify-send "Bluetooth" "Disconnected from $name" -i bluetooth
            elif echo "$selection" | grep -q "(new)"; then
                notify-send "Bluetooth" "Pairing with $name..." -i bluetooth
                bluetoothctl pair "$mac" && bluetoothctl connect "$mac"
            else
                notify-send "Bluetooth" "Connecting to $name..." -i bluetooth
                bluetoothctl connect "$mac"
            fi
            ;;
    esac
fi
