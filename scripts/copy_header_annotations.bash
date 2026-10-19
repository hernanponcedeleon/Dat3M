#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <source_file> <destination_file> [annotation...]"
    echo "Copies the '//;' header annotations of the source to the beginning of the destination."
    echo "If annotation names (e.g. @Locations) are given, only those annotations are copied."
    exit 1
fi

SOURCE_FILE="$1"
DEST_FILE="$2"
shift 2

PATTERN='^//;'
if [ "$#" -gt 0 ]; then
    NAMES=$(IFS='|'; echo "$*")
    PATTERN="^//;[[:space:]]*(${NAMES})"
fi

{
    grep -E "$PATTERN" "$SOURCE_FILE" | sed 's|^//||'
    cat "$DEST_FILE"
} > "${DEST_FILE}.tmp" && mv "${DEST_FILE}.tmp" "$DEST_FILE"
