#!/usr/bin/env bash

set +H
set -f

# --- Setup & Validation ---

if ! command -v magick &> /dev/null; then
    echo "Error: ImageMagick (magick) not found."
    exit 1
fi

# --- Argument Parsing ---
MONOCHROME=false
INPUT_ARG=""

for arg in "$@"; do
    case $arg in
        --monochrome|--mono)
            MONOCHROME=true
            ;;
        *)
            INPUT_ARG="$arg"
            ;;
    esac
done

if [ -z "$INPUT_ARG" ]; then
    echo "Usage: $0 [--monochrome] <image_file>"
    exit 1
fi

INPUT_PATH=$(realpath -- "$INPUT_ARG")
if [ ! -f "$INPUT_PATH" ]; then
    echo "Error: File not found: $INPUT_PATH"
    exit 1
fi

DIR=$(dirname -- "$INPUT_PATH")
FILE_PATH=$(basename -- "$INPUT_PATH")
OUT_DIR="${DIR}"
mkdir -p "$OUT_DIR"

MONO_SUFFIX=""
[ "$MONOCHROME" = true ] && MONO_SUFFIX="+mono"

# Get dimensions (suppress warnings from identify)
DIMENSIONS=$(magick identify -format "%w %h" "$INPUT_PATH" 2>/dev/null)
ORIG_W=$(echo "$DIMENSIONS" | cut -d' ' -f1)
ORIG_H=$(echo "$DIMENSIONS" | cut -d' ' -f2)

if [ "$ORIG_W" -ne "$ORIG_H" ]; then
    echo "[!] Image is not square ($ORIG_W x $ORIG_H), exiting..."
    exit 1
fi

# --- Helper: Oklab Desaturation Commands ---
# We define these as arrays to inject them cleanly into the command
PRE_MONO=()
POST_MONO=()
if [ "$MONOCHROME" = true ]; then
    # Pass 1: Initial desaturation
    PRE_MONO=(-colorspace Oklab -channel 1,2 -evaluate set 50% +channel)
    # Pass 2: Clean up any interpolation artifacts after resize
    POST_MONO=(-colorspace Oklab -channel 1,2 -evaluate set 50% +channel)
fi

# --- The Resampling Logic Function ---

process_size() {
    local TARGET_SIZE="$1"

    # CASE 1: Exact size match
    if [ "$ORIG_W" -eq "$TARGET_SIZE" ]; then
        if [ "$MONOCHROME" = false ]; then
            local FILENAME="${FILE_PATH}+none+${TARGET_SIZE}.png"
            local OUT_PATH="${OUT_DIR}/${FILENAME}"
            cp "$INPUT_PATH" "$OUT_PATH"
            echo "[~] > [${TARGET_SIZE}] $FILENAME [Resampling Skipped]"
        else
            local FILENAME="${FILE_PATH}${MONO_SUFFIX}+none+${TARGET_SIZE}.png"
            local OUT_PATH="${OUT_DIR}/${FILENAME}"
            # Only need one pass since there's no resizing interpolation
            magick "$INPUT_PATH" "${PRE_MONO[@]}" -colorspace sRGB -strip "$OUT_PATH"
            echo "[*] > [${TARGET_SIZE}] $FILENAME [Resampling Skipped]"
        fi
        return
    fi

    # CASE 2: Upscaling (Mitchell)
    if [ "$TARGET_SIZE" -gt "$ORIG_W" ]; then
        local FILENAME="${FILE_PATH}${MONO_SUFFIX}+mitchell+${TARGET_SIZE}.png"
        local OUT_PATH="${OUT_DIR}/${FILENAME}"

        magick "$INPUT_PATH" \
            "${PRE_MONO[@]}" \
            -colorspace Oklab \
            -filter Mitchell \
            -distort Resize "${TARGET_SIZE}x${TARGET_SIZE}" \
            "${POST_MONO[@]}" \
            -colorspace sRGB \
            -strip \
            "$OUT_PATH"

        echo "[+] > [${TARGET_SIZE}] $FILENAME [Upscaled]"
        
    # CASE 3: Downscaling (Lanczos)
    else
        local FILENAME="${FILE_PATH}${MONO_SUFFIX}+lanczos+${TARGET_SIZE}.png"
        local OUT_PATH="${OUT_DIR}/${FILENAME}"

        magick "$INPUT_PATH" \
            "${PRE_MONO[@]}" \
            -colorspace RGB \
            -filter Lanczos \
            -distort Resize "${TARGET_SIZE}x${TARGET_SIZE}" \
            "${POST_MONO[@]}" \
            -colorspace sRGB \
            -strip \
            "$OUT_PATH"

        echo "[-] > [${TARGET_SIZE}] $FILENAME [Downscaled]"
    fi
}

# --- Execution ---

MODE_STR="Color"
[ "$MONOCHROME" = true ] && MODE_STR="Monochrome"

echo "[>] Starting Resampling for: $INPUT_ARG [${ORIG_W}x${ORIG_H}px] [$MODE_STR]"

process_size 1080
process_size 1440
process_size 2160
