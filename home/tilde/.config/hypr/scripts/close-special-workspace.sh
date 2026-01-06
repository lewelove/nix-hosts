#!/usr/bin/env bash

active_special=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .specialWorkspace.name | select(. != "")')

if [ -n "$active_special" ]; then

    clean_name=${active_special#special:}
    
    hyprctl dispatch togglespecialworkspace "$clean_name"
fi
