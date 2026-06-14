#!/bin/bash

# Weather for Lisbon using Open-Meteo API

CACHE_FILE="/tmp/weather-cache"
CACHE_AGE=1800  # 30 minutes

# Lisbon coordinates
LAT="38.7167"
LON="-9.1333"

# Check cache
if [[ -f "$CACHE_FILE" ]]; then
    age=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE")))
    if [[ $age -lt $CACHE_AGE ]]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

# Fetch weather
data=$(curl -sf "https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current=temperature_2m,apparent_temperature,relative_humidity_2m,weather_code&timezone=Europe/Lisbon" 2>/dev/null)

if [[ -z "$data" ]]; then
    echo '{"text": "󰼯 --°", "tooltip": "Weather unavailable"}'
    exit 0
fi

temp=$(echo "$data" | jq -r '.current.temperature_2m | floor')
feels=$(echo "$data" | jq -r '.current.apparent_temperature | floor')
humidity=$(echo "$data" | jq -r '.current.relative_humidity_2m')
code=$(echo "$data" | jq -r '.current.weather_code')

# WMO Weather codes to nerd font icons and descriptions
case "$code" in
    0) icon="󰖙"; desc="Clear" ;;
    1) icon="󰖙"; desc="Mainly Clear" ;;
    2) icon="󰖐"; desc="Partly Cloudy" ;;
    3) icon="󰖐"; desc="Overcast" ;;
    45|48) icon="󰖑"; desc="Fog" ;;
    51|53|55) icon="󰖗"; desc="Drizzle" ;;
    56|57) icon="󰙿"; desc="Freezing Drizzle" ;;
    61|63|65) icon="󰖖"; desc="Rain" ;;
    66|67) icon="󰙿"; desc="Freezing Rain" ;;
    71|73|75|77) icon="󰼶"; desc="Snow" ;;
    80|81|82) icon="󰖖"; desc="Showers" ;;
    85|86) icon="󰼶"; desc="Snow Showers" ;;
    95|96|99) icon="󰖓"; desc="Thunderstorm" ;;
    *) icon="󰖐"; desc="Unknown" ;;
esac

output=$(cat <<EOF
{"text": "$icon ${temp}°", "tooltip": "$desc\nFeels like: ${feels}°C\nHumidity: ${humidity}%"}
EOF
)

echo "$output" > "$CACHE_FILE"
echo "$output"
