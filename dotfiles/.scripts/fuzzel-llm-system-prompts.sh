#!/usr/bin/env bash

INSTRUCTIONS_DIR="$HOME/.config/fuzzel/llm-system-prompts"

selection=$(fd --max-depth 1 --type f --extension xml . "$INSTRUCTIONS_DIR" --exec basename {} .xml | fuzzel --dmenu --prompt="Inject Instruction: ")

[[ -z "$selection" ]] && exit 0

target_file="$INSTRUCTIONS_DIR/${selection}.xml"

raw_content=$(cat "$target_file")

echo -n "$raw_content" | wl-copy

sleep 0.05
wtype -M ctrl v -m ctrl
sleep 0.05
