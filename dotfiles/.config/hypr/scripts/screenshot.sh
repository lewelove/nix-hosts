#!/usr/bin/env bash

# Usage: ./screenshot.sh [window|output|region]

MODE=$1
DIR="$HOME/Pictures/Screenshots"
TIMESTAMP=$(date +'%Y%m%d-%H%M%S%3N')

if [ "$MODE" == "window" ]; then

    CLASS=$(hyprctl activewindow | awk -F ': ' '/class:/ {print $2}')
    
    [ -z "$CLASS" ] && CLASS="active-window"
    
    CLASS=${CLASS//[^a-zA-Z0-9]/_}
    
    FILENAME="${TIMESTAMP}-${CLASS}.png"

elif [ "$MODE" == "output" ]; then
    FILENAME="${TIMESTAMP}-fullscreen.png"

else
    FILENAME="${TIMESTAMP}-region.png"
fi

mkdir -p "$DIR"

exec hyprshot --freeze -m "$MODE" -o "$DIR" -f "$FILENAME"
