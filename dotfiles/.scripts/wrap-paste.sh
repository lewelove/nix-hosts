#!/usr/bin/env bash

CONTENT=$(wl-paste)
if [ -z "$CONTENT" ]; then
    exit 0
fi

wtype -k Return
wtype '```'
wtype -k Return

wtype -M ctrl v -m ctrl

sleep 0.1

wtype -k Return
wtype '```'
wtype -k Return
