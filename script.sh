#!/bin/bash

set -o pipefail

if [[ -z "$1" ]]; then
    echo "No origin folder"
    exit
else
    ORIG="$1"
fi

DEST="/home/zaraksh/mp3"
LOGS="logs"

for dirname in "$ORIG"/*; do
    DIRNAME="${dirname#"$ORIG"/}"
    LOG_FILE="$LOGS/$(echo "$DIRNAME" | sed -e 's/[ \|(\|)\|]/_/g' | sed -e 's/[.\|!\|\|&\|+\|-]//g').log"
    echo "$DIRNAME: $LOG_FILE"
    for file in "$ORIG"/"$DIRNAME"/*; do
        FILENAME="${file##*/}"
        IN_FILE="$ORIG/$FILENAME"
        if [[ ${FILENAME##*.} == "flac" ]]; then
            OUT_FILE="$DEST/${FILENAME%.flac}.mp3"
            echo "ffmpeg -i "$IN_FILE" -b:a 320k "$OUT_FILE" &"
        else
            OUT_FILE="$DEST/$FILENAME"
            echo "cp "$IN_FILE" "$OUT_FILE""
        fi
    done
    echo -e "\n\n"
done
