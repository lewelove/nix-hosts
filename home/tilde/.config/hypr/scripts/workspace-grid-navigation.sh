#!/usr/bin/env bash

# Get current workspace ID
CURRENT=$(hyprctl activeworkspace -j | jq -r '.id')

# Validate it's a valid grid workspace (11-99, not ending with 0)
if ! (( CURRENT >= 11 && CURRENT <= 99 && CURRENT % 10 != 0 )); then
    exit 0
fi

ROW=$(( CURRENT / 10 ))
COL=$(( CURRENT % 10 ))
TARGET=""

case "$1" in
    left)
        if (( COL > 1 )); then
            TARGET=$(( CURRENT - 1 ))
            hyprctl keyword animation workspaces,1,2.5,almostLinear,slidefade
        fi
        ;;
    right)
        if (( COL < 9 )); then
            TARGET=$(( CURRENT + 1 ))
            hyprctl keyword animation workspaces,1,2.5,almostLinear,slidefade
        fi
        ;;
		down)  # SUPER+J → previous row, column 1
        if (( ROW > 1 )); then
            TARGET=$(( (ROW - 1) * 10 + 1 ))
            hyprctl keyword animation workspaces,1,2.5,almostLinear,slidevertfade
        fi
        ;;
    up)  # SUPER+K → next row, column 1
        if (( ROW < 9 )); then
            TARGET=$(( (ROW + 1) * 10 + 1 ))
            hyprctl keyword animation workspaces,1,2.5,almostLinear,slidevertfade
        fi
        ;;
esac

# Perform the switch if we have a valid target
if [[ -n "$TARGET" ]]; then
    hyprctl dispatch workspace "$TARGET"
fi
