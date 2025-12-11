#!/bin/bash
# $HOME/.config/hypr/scripts/popup_close.sh

CLOSED_ADDR="0x$1"
STATE_FILE="/tmp/hypr_popup_state"

[ ! -f "$STATE_FILE" ] && exit 0
source "$STATE_FILE" # Loads POPUP_ADDR, PARENT_ADDR, CURSOR_X, CURSOR_Y

CLOSED_UPPER=${CLOSED_ADDR^^}
SAVED_UPPER=${POPUP_ADDR^^}

if [ "$CLOSED_UPPER" == "$SAVED_UPPER" ]; then
    
    hyprctl dispatch focuswindow "address:$PARENT_ADDR"

    hyprctl dispatch movecursor "$CURSOR_X" "$CURSOR_Y"
    
    rm "$STATE_FILE"
fi
