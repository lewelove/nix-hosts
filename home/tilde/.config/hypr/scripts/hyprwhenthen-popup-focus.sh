#!/bin/bash

POPUP_ADDRESS="0x$1"

hyprctl dispatch togglefloating "address:$POPUP_ADDRESS"
hyprctl dispatch resizewindowpixel exact 40% 60%,"address:$POPUP_ADDRESS"
hyprctl dispatch centerwindow "address:$POPUP_ADDRESS"
hyprctl dispatch focuswindow "address:$POPUP_ADDRESS"
