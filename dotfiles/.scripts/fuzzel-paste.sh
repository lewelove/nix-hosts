#!/usr/bin/env bash

OPTIONS="YYYYMMDD"

selection=$(echo -e "$OPTIONS" | fuzzel --dmenu --prompt="Paste: " --lines 1 --width 20)

[[ -z "$selection" ]] && exit 0

case "$selection" in
    "YYYYMMDD")
        echo -n "$(date +'%Y%m%d')" | wl-copy
        ;;
esac

wtype -M ctrl v -m ctrl
