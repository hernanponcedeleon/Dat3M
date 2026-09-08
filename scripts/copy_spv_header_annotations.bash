#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_file> <destination_file>"
    exit 1
fi

SOURCE_FILE="$1"
DEST_FILE="$2"

{
    grep '^//;' "$SOURCE_FILE" | sed 's|^//||'
    cat "$DEST_FILE"
} > "${DEST_FILE}.tmp" && mv "${DEST_FILE}.tmp" "$DEST_FILE"