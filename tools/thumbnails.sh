#!/bin/bash

INPUT_DIR="../images/featured"
OUTPUT_DIR="../images/featured"
WIDTHS="180 360 720"

SCRIPT_DIR=$(dirname $(realpath "$0"))
cd $SCRIPT_DIR
cd $INPUT_DIR

shopt -s extglob nullglob
for input in *.@(png|jpg); do 
    echo "Checking $input"; 
    base=$(basename "$input" | cut -d. -f1)
    ext="${input##*.}"
    for WIDTH in $WIDTHS; do
        output="${SCRIPT_DIR}/${OUTPUT_DIR}/${base}.${ext}_${WIDTH}"
        if [ ! -f "$output" ]; then
            echo "  Generating thumbnail width=$WIDTH"
            convert "$input" -resize $WIDTH\> "$output"
        fi
    done
done
