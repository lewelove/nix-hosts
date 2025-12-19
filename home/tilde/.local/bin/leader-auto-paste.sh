#!/usr/bin/env bash

# Source the styling
if [ -f "$HOME/.config/bemenu/config" ]; then
    source "$HOME/.config/bemenu/config"
fi

# Define your commands here
# Format: ["cmd"]="text to paste"
declare -A snippets
snippets=(
    ["dc"]=" **do not** write code yet, think about my questions and ideas i just provided and reason through them. "
    ["cot"]=" think step-by-step. reason through the logic out loud before providing the final answer."
    ["brief"]=" be extremely concise. no yapping, no 'here is your code', just the raw output."
    ["ref"]=" refactor this code for readability and performance without changing functionality."
    ["crit"]=" find the flaws in my logic. act as a devil's advocate and try to break my proposal."
    ["arch"]=" high-level architecture only. focus on data flow and state management. no implementation yet."
)

# Generate list of keys for bemenu
keys=$(printf "%s\n" "${!snippets[@]}" | sort)

# Launch bemenu
# BEMENU_OPTS is picked up from the sourced config
choice=$(echo "$keys" | bemenu -p "LLM Leader:")

# If a choice was made, type it
if [ -n "$choice" ] && [ -n "${snippets[$choice]}" ]; then
    # Tiny sleep to let bemenu window close so the target window regains focus
    sleep 0.1
    wtype "${snippets[$choice]}"
fi
