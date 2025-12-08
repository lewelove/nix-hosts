#!/bin/bash
# $HOME/.config/hypr/scripts/popup_open.sh

POPUP_ADDR="0x$1"
STATE_FILE="/tmp/hypr_popup_state"

CURSOR_X=$(hyprctl cursorpos -j | jq -r '.x')
CURSOR_Y=$(hyprctl cursorpos -j | jq -r '.y')

hyprctl dispatch focuscurrentorlast

# Get parent address before focusing the popup
PARENT_ADDR=$(hyprctl activewindow -j | jq -r '.address')

# Save state to temp file
echo "POPUP_ADDR=$POPUP_ADDR" > "$STATE_FILE"
echo "PARENT_ADDR=$PARENT_ADDR" >> "$STATE_FILE"
echo "CURSOR_X=$CURSOR_X" >> "$STATE_FILE"
echo "CURSOR_Y=$CURSOR_Y" >> "$STATE_FILE"

source "$STATE_FILE"

# Apply styling and focus commands (as short as possible)
hyprctl dispatch togglefloating "address:$POPUP_ADDR"
hyprctl dispatch focuswindow "address:$POPUP_ADDR"
hyprctl dispatch resizewindowpixel exact 40% 60%,"address:$POPUP_ADDR"
hyprctl dispatch centerwindow
hyprctl dispatch focuswindow "address:$POPUP_ADDR"

# (Include your five Tab commands here if necessary, or put them back in config.toml)
