#!/usr/bin/env bash

CLEAN_PATH="$1"
CLEAN_PATH="${CLEAN_PATH#\'}"
CLEAN_PATH="${CLEAN_PATH%\'}"
CLEAN_PATH="${CLEAN_PATH#\"}"
CLEAN_PATH="${CLEAN_PATH%\"}"

IMAGE=$(readlink -f "$CLEAN_PATH")

if [ -z "$IMAGE" ] || [ ! -f "$IMAGE" ]; then
    notify-send "Wallpaper Error" "Image not found."
    exit 1
fi

awww img "$IMAGE" \
    --transition-type grow \
    --transition-pos 0.5,0.5 \
    --transition-fps 60 \
    --transition-duration 1

notify-send "Wallpaper Changed" "$(basename "$IMAGE")"

