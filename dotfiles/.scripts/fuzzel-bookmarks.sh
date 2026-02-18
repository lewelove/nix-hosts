#!/usr/bin/env bash

FILE="$HOME/.config/fuzzel/bookmarks.txt"

selection=$(awk -F'=' '{print $1}' "$FILE" | fuzzel --dmenu --prompt="Bookmark: ")

[[ -z "$selection" ]] && exit 0

line=$(grep "^$selection=" "$FILE")
url="${line#*=}"

xdg-open "$url"
