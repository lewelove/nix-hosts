#!/usr/bin/env bash

IS_FLOATING=$(hyprctl activewindow -j | jq -r '.floating')

if [ "$IS_FLOATING" = "false" ]; then

    hyprctl dispatch togglefloating
    
    hyprctl dispatch resizeactive exact 70% 95%
    
    hyprctl dispatch centerwindow

    MON_HEIGHT=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .height / .scale')
    NUDGE_Y=$(awk -v h="$MON_HEIGHT" 'BEGIN { printf "%.0f", (h * 0.025) - 8 }')

    hyprctl dispatch moveactive 0 "$NUDGE_Y"

else

    hyprctl dispatch togglefloating

fi
