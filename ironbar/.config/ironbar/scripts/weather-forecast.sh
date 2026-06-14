#!/usr/bin/env bash

# Weather Forecast with Nerd Font Icons
# Uses Open-Meteo API (no key required)

# Lisbon coordinates
LAT="38.7167"
LON="-9.1333"
TIMEZONE="Europe/Lisbon"

# Colors (using terminal ANSI)
BOLD="\033[1m"
DIM="\033[2m"
RESET="\033[0m"
CYAN="\033[36m"
YELLOW="\033[33m"

# WMO Weather codes to Nerd Font icons
get_icon() {
    case $1 in
        0) echo "󰖙" ;;          # Clear sky
        1) echo "󰖙" ;;          # Mainly clear
        2) echo "󰖐" ;;          # Partly cloudy
        3) echo "󰖐" ;;          # Overcast
        45|48) echo "󰖑" ;;      # Fog
        51|53|55) echo "󰖗" ;;   # Drizzle
        56|57) echo "󰙿" ;;      # Freezing drizzle
        61|63|65) echo "󰖖" ;;   # Rain
        66|67) echo "󰙿" ;;      # Freezing rain
        71|73|75) echo "󰼶" ;;   # Snow
        77) echo "󰼶" ;;         # Snow grains
        80|81|82) echo "󰖖" ;;   # Rain showers
        85|86) echo "󰼶" ;;      # Snow showers
        95) echo "󰖓" ;;         # Thunderstorm
        96|99) echo "󰖓" ;;      # Thunderstorm with hail
        *) echo "󰖐" ;;
    esac
}

# WMO Weather codes to descriptions
get_desc() {
    case $1 in
        0) echo "Clear" ;;
        1) echo "Mainly Clear" ;;
        2) echo "Partly Cloudy" ;;
        3) echo "Overcast" ;;
        45) echo "Fog" ;;
        48) echo "Rime Fog" ;;
        51) echo "Light Drizzle" ;;
        53) echo "Drizzle" ;;
        55) echo "Dense Drizzle" ;;
        56|57) echo "Freezing Drizzle" ;;
        61) echo "Light Rain" ;;
        63) echo "Rain" ;;
        65) echo "Heavy Rain" ;;
        66|67) echo "Freezing Rain" ;;
        71) echo "Light Snow" ;;
        73) echo "Snow" ;;
        75) echo "Heavy Snow" ;;
        77) echo "Snow Grains" ;;
        80) echo "Light Showers" ;;
        81) echo "Showers" ;;
        82) echo "Heavy Showers" ;;
        85) echo "Light Snow Showers" ;;
        86) echo "Snow Showers" ;;
        95) echo "Thunderstorm" ;;
        96|99) echo "Thunderstorm + Hail" ;;
        *) echo "Unknown" ;;
    esac
}

# Fetch data
DATA=$(curl -sf "https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&daily=weather_code,temperature_2m_max,temperature_2m_min&hourly=temperature_2m,weather_code&timezone=${TIMEZONE}&forecast_days=7")

if [[ -z "$DATA" ]]; then
    echo "Failed to fetch weather data"
    exit 1
fi

# Parse JSON
readarray -t DATES < <(echo "$DATA" | jq -r '.daily.time[]')
readarray -t CODES < <(echo "$DATA" | jq -r '.daily.weather_code[]')
readarray -t MAXS < <(echo "$DATA" | jq -r '.daily.temperature_2m_max[]')
readarray -t MINS < <(echo "$DATA" | jq -r '.daily.temperature_2m_min[]')
readarray -t HOURLY_TEMPS < <(echo "$DATA" | jq -r '.hourly.temperature_2m[]')
readarray -t HOURLY_CODES < <(echo "$DATA" | jq -r '.hourly.weather_code[]')

# Header
echo ""
echo -e "${BOLD}${CYAN}  󰖐  Weather${RESET}"
echo ""
# Header with icons for morning/afternoon/night
echo -e "${BOLD}                                       󰖨          󰖙          󰖔${RESET}"
echo ""

# Each day
for i in "${!DATES[@]}"; do
    date="${DATES[$i]}"
    code="${CODES[$i]}"
    max="${MAXS[$i]%.*}"
    min="${MINS[$i]%.*}"
    icon=$(get_icon "$code")
    desc=$(get_desc "$code")

    # Format date
    day_name=$(date -d "$date" +"%a %d")

    # Get hourly data for this day (24 hours per day)
    base=$((i * 24))

    # Morning (6-11): indices 6-11
    morning_temps=()
    morning_code=0
    for h in 6 7 8 9 10 11; do
        idx=$((base + h))
        if [[ $idx -lt ${#HOURLY_TEMPS[@]} ]]; then
            morning_temps+=("${HOURLY_TEMPS[$idx]%.*}")
            morning_code="${HOURLY_CODES[$idx]}"
        fi
    done
    if [[ ${#morning_temps[@]} -gt 0 ]]; then
        m_min=$(printf '%s\n' "${morning_temps[@]}" | sort -n | head -1)
        m_max=$(printf '%s\n' "${morning_temps[@]}" | sort -n | tail -1)
        m_icon=$(get_icon "$morning_code")
    else
        m_min="--"; m_max="--"; m_icon="󰖐"
    fi

    # Afternoon (12-17): indices 12-17
    afternoon_temps=()
    afternoon_code=0
    for h in 12 13 14 15 16 17; do
        idx=$((base + h))
        if [[ $idx -lt ${#HOURLY_TEMPS[@]} ]]; then
            afternoon_temps+=("${HOURLY_TEMPS[$idx]%.*}")
            afternoon_code="${HOURLY_CODES[$idx]}"
        fi
    done
    if [[ ${#afternoon_temps[@]} -gt 0 ]]; then
        a_min=$(printf '%s\n' "${afternoon_temps[@]}" | sort -n | head -1)
        a_max=$(printf '%s\n' "${afternoon_temps[@]}" | sort -n | tail -1)
        a_icon=$(get_icon "$afternoon_code")
    else
        a_min="--"; a_max="--"; a_icon="󰖐"
    fi

    # Night (18-23): indices 18-23
    night_temps=()
    night_code=0
    for h in 18 19 20 21 22 23; do
        idx=$((base + h))
        if [[ $idx -lt ${#HOURLY_TEMPS[@]} ]]; then
            night_temps+=("${HOURLY_TEMPS[$idx]%.*}")
            night_code="${HOURLY_CODES[$idx]}"
        fi
    done
    if [[ ${#night_temps[@]} -gt 0 ]]; then
        n_min=$(printf '%s\n' "${night_temps[@]}" | sort -n | head -1)
        n_max=$(printf '%s\n' "${night_temps[@]}" | sort -n | tail -1)
        n_icon=$(get_icon "$night_code")
    else
        n_min="--"; n_max="--"; n_icon="󰖐"
    fi

    # Build the line with manual spacing (nerd fonts are ~2 chars wide)
    # Format: "day    range° icon desc          icon temp°   icon temp°   icon temp°"
    range=$(printf "%2s-%-2s°" "$min" "$max")
    desc_pad=$(printf "%-14s" "$desc")
    m_temp=$(printf "%2s-%-2s°" "$m_min" "$m_max")
    a_temp=$(printf "%2s-%-2s°" "$a_min" "$a_max")
    n_temp=$(printf "%2s-%-2s°" "$n_min" "$n_max")

    line="${day_name}   ${range} ${icon} ${desc_pad}   ${m_icon} ${m_temp}  ${a_icon} ${a_temp}  ${n_icon} ${n_temp}"

    # Highlight today
    if [[ "$date" == "$(date +%Y-%m-%d)" ]]; then
        echo -e "${YELLOW}${line}${RESET}"
    else
        echo "$line"
    fi
done

echo ""

read -rsn1
