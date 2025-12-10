#!/usr/bin/env sh

# Using awk on raw text is faster than generating and parsing JSON.
# We look for the block containing "focused: yes" and extract the special workspace name.

active=$(hyprctl monitors | awk '
    /^Monitor/ { in_block=1; has_focused=0; special="" }
    /focused: yes/ { has_focused=1 }
    /specialWorkspace: special:/ { special=$2 }
    /^$/ { 
        if (in_block && has_focused && special != "") { print special; exit }
        in_block=0 
    }
    END { if (in_block && has_focused && special != "") print special }
')

if [ -n "$active" ]; then
    # Strip "special:" prefix
    clean=${active#special:}
    hyprctl dispatch togglespecialworkspace "$clean"
fi
