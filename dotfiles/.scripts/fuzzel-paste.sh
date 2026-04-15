#!/usr/bin/env bash

OPTIONS=(
    "YYYYMMDD"
    "Unix Epoch"
)

selection=$(printf "%s\n" "${OPTIONS[@]}" | fuzzel --dmenu --prompt="Paste: " --width 20)

[[ -z "$selection" ]] && exit 0

case "$selection" in
    "YYYYMMDD")
        echo -n "$(date +'%Y%m%d')" | wl-copy
        ;;
    "Unix Epoch")
        echo -n "$(date +%s)" | wl-copy
        ;;
esac

wtype -M ctrl v -m ctrl
