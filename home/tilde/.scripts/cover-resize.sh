#!/usr/bin/env bash

# 1. Disable history expansion so '!' is treated as a literal character
# 2. Disable globbing (optional but safer) to prevent '*' or '?' from expanding
set +H
set -f

# --- Setup & Validation ---

if ! command -v magick &> /dev/null; then
    echo "Error: ImageMagick (magick) not found."
    exit 1
fi

if [ -z "$1" ]; then
    echo "Usage: $0 <image_file>"
    exit 1
fi

# Use quotes around "$1" to catch files with spaces/symbols
INPUT_PATH=$(realpath -- "$1")

if [ ! -f "$INPUT_PATH" ]; then
    echo "Error: File not found: $INPUT_PATH"
    exit 1
fi

# Prepare path variables - always quote expansions
DIR=$(dirname -- "$INPUT_PATH")
FILE_PATH=$(basename -- "$INPUT_PATH")
OUT_DIR="${DIR}"

# Create the directory
mkdir -p "$OUT_DIR"

# Get dimensions - use quotes for $INPUT_PATH
DIMENSIONS=$(magick identify -format "%w %h" "$INPUT_PATH")
ORIG_W=$(echo "$DIMENSIONS" | cut -d' ' -f1)
ORIG_H=$(echo "$DIMENSIONS" | cut -d' ' -f2)

if [ "$ORIG_W" -ne "$ORIG_H" ]; then
    echo "[!] Image is not square ($ORIG_W x $ORIG_H), exiting..."
    exit 1
fi

# --- The Resampling Logic Function ---

process_size() {
    local TARGET_SIZE="$1"

    if [ "$ORIG_W" -eq "$TARGET_SIZE" ]; then
        local FILENAME="${FILE_PATH}+${TARGET_SIZE}+none+${TARGET_SIZE}.png"
        local OUT_PATH="${OUT_DIR}/${FILENAME}"

        cp "$INPUT_PATH" "$OUT_PATH"
        echo "[~] > [${TARGET_SIZE}] $FILENAME [Resampling Skipped]"
        return
    fi

    # Create the filename safely by quoting the whole string
    if [ "$TARGET_SIZE" -gt "$ORIG_W" ]; then
        local FILENAME="${FILE_PATH}+${ORIG_W}+mitchell+${TARGET_SIZE}.png"
        local OUT_PATH="${OUT_DIR}/${FILENAME}"

        magick "$INPUT_PATH" \
            -colorspace Oklab \
            -filter Mitchell \
            -distort Resize "${TARGET_SIZE}x${TARGET_SIZE}" \
            -colorspace sRGB \
            "$OUT_PATH"

        echo "[+] > [${TARGET_SIZE}] $FILENAME [Upscaled]"
    else
        local FILENAME="${FILE_PATH}+$ORIG_W+lanczos+${TARGET_SIZE}.png"
        local OUT_PATH="${OUT_DIR}/${FILENAME}"

        magick "$INPUT_PATH" \
            -colorspace RGB \
            -filter Lanczos \
            -distort Resize "${TARGET_SIZE}x${TARGET_SIZE}" \
            -colorspace sRGB \
            "$OUT_PATH"

        echo "[+] > [${TARGET_SIZE}] $FILENAME [Downscaled]"
    fi
}

# --- Execution ---

echo "[>] Starting Resampling for: $1 [${ORIG_W}x${ORIG_H}px]"

process_size 2160
process_size 1440
process_size 1080
