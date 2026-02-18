#!/usr/bin/env bash

FILE="${1:-$HOME/.config/fuzzel/auto-paste.txt}"

declare -A snippets

keys=()

while IFS='=' read -r key value || [[ -n "$key" ]]; do

    [[ -z "$key" || "$key" == \#* ]] && continue

    clean_value="${value%\"}"
    clean_value="${clean_value#\"}"

    snippets["$key"]="$clean_value"
    keys+=("$key")
done < "$FILE"

selection=$(printf "%s\n" "${keys[@]}" | fuzzel --dmenu)

[[ -z "$selection" ]] && exit 0

echo -n "${snippets[$selection]}" | wl-copy

wtype -M ctrl v -m ctrl

