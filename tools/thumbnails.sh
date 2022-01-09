#!/bin/bash

INPUT_DIR="../images/featured/*"
OUTPUT_DIR="../images/thumbnails"
OUTPUT_DIR="../images/featured/"
WIDTHS="180 360 720"

for input in $INPUT_DIR; do 
    echo "Processing $input file.."; 
    base=$(basename "$input" | cut -d. -f1)
    ext="${input##*.}"
    for WIDTH in $WIDTHS; do
        # output="${OUTPUT_DIR}/${base}_${WIDTH}.${ext}"
        output="${OUTPUT_DIR}/${base}.${ext}_${WIDTH}"
        if [ ! -f "$output" ]; then
            echo "Generating thumbnail width=$WIDTH"
            convert "$input" -resize $WIDTH\> "$output"
        fi
    done
done
