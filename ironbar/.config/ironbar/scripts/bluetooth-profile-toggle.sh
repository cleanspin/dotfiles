#!/usr/bin/env bash

# Toggle Bluetooth audio profile between A2DP (high quality) and HSP/HFP (mic enabled)
# Used for the ironbar bluetooth module right-click action

# Find the bluetooth card
BT_CARD=$(pactl list cards short 2>/dev/null | grep bluez_card | head -1 | awk '{print $2}')

if [[ -z "$BT_CARD" ]]; then
    notify-send "Bluetooth" "No bluetooth audio device connected" -i bluetooth-disabled
    exit 1
fi

# Get current profile
CURRENT_PROFILE=$(pactl list cards 2>/dev/null | grep -A 50 "$BT_CARD" | grep "Active Profile:" | sed 's/.*: //')

# Get device name for notification
DEVICE_NAME=$(pactl list cards 2>/dev/null | grep -A 20 "$BT_CARD" | grep "device.description" | sed 's/.*= "\(.*\)"/\1/')

if [[ "$CURRENT_PROFILE" == a2dp* ]]; then
    # Switch to HSP/HFP (prefer mSBC for better quality)
    if pactl set-card-profile "$BT_CARD" headset-head-unit 2>/dev/null; then
        notify-send "Bluetooth: Call Mode" "$DEVICE_NAME\nMicrophone enabled (lower audio quality)" -i audio-input-microphone
    else
        notify-send "Bluetooth Error" "Failed to switch to headset profile" -i dialog-error
    fi
else
    # Switch to A2DP (prefer AAC, fallback to SBC)
    if pactl set-card-profile "$BT_CARD" a2dp-sink 2>/dev/null || \
       pactl set-card-profile "$BT_CARD" a2dp-sink-sbc 2>/dev/null; then
        notify-send "Bluetooth: Music Mode" "$DEVICE_NAME\nHigh quality audio (no microphone)" -i audio-headphones
    else
        notify-send "Bluetooth Error" "Failed to switch to A2DP profile" -i dialog-error
    fi
fi
