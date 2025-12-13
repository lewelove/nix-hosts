#!/usr/bin/env bash

notify-send "Wallpaper Warning"
# 1. Get the Image Path (Absolute)
#    We use readlink to ensure we have the full path even if Thunar behaves oddly.
IMAGE=$(readlink -f "$1")

if [ -z "$IMAGE" ] || [ ! -f "$IMAGE" ]; then
    notify-send "Wallpaper Error" "Image not found: $1"
    exit 1
fi

# 2. Get the Focused Monitor
#    We use jq to extract the name of the monitor currently in focus.
MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')

if [ -z "$MONITOR" ]; then
    # Fallback to wildcard (all monitors) if detection fails
    MONITOR=","
    notify-send "Wallpaper Warning" "Could not detect monitor, applying to all."
fi

# 3. Execute Hyprpaper Commands
hyprctl hyprpaper preload "$IMAGE"
hyprctl hyprpaper wallpaper "$MONITOR,$IMAGE"
