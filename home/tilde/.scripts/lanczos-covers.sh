#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <image_file>"
    exit 1
fi

INPUT_FILE="$1"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

DIR=$(dirname "$INPUT_FILE")
FILENAME=$(basename -- "$INPUT_FILE")

OUTPUT_FILE_1080="${DIR}/${FILENAME}+lanczos+1080.png"
OUTPUT_FILE_1440="${DIR}/${FILENAME}+lanczos+1440.png"
OUTPUT_FILE_2160="${DIR}/${FILENAME}+lanczos+2160.png"

echo "[>] Resampling '$FILENAME'..."

magick "$INPUT_FILE" \
    -filter Lanczos \
    -resize 1080x1080 \
    "$OUTPUT_FILE_1080"

magick "$INPUT_FILE" \
    -filter Lanczos \
    -resize 1440x1440 \
    "$OUTPUT_FILE_1440"

magick "$INPUT_FILE" \
    -filter Lanczos \
    -resize 2160x2160 \
    "$OUTPUT_FILE_2160"

if [ $? -eq 0 ]; then
    echo "[+] Files Resampled:"
    echo "$OUTPUT_FILE_1080"
    echo "$OUTPUT_FILE_1440"
    echo "$OUTPUT_FILE_2160"
else
    echo "[!] Resampling failed."
    exit 1
fi
