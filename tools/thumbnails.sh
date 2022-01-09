#!/bin/bash

INPUT_DIR="../images/featured/*"
OUTPUT_DIR="../images/thumbnails"
WIDTHS="180 360 720"

for input in $INPUT_DIR; do 
    echo "Processing $input file.."; 
    base=$(basename "$input" | cut -d. -f1)
    ext="${input##*.}"
    for WIDTH in $WIDTHS; do
        output="${OUTPUT_DIR}/${base}_${WIDTH}.${ext}"
        if [ ! -f "$output" ]; then
            echo "Generating thumbnail width=$WIDTH"
            magick "$input" -resize $WIDTH "$output"
        fi
    done
done
