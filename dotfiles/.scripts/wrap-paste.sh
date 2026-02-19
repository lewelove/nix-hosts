#!/usr/bin/env bash

CONTENT=$(wl-paste)

if [ -z "$CONTENT" ]; then
    exit 0
fi

WRAPPED=$(printf '\n```\n%s\n```\n' "$CONTENT")

echo -n "$WRAPPED" | wl-copy

sleep 0.05
wtype -M ctrl v -m ctrl
