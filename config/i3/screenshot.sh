#!/bin/bash

# Define the directory and base filename
DIRECTORY="$HOME/Pictures/screenshots"
BASE_FILENAME="screenshot"
FILE_EXTENSION="png"

# Create the directory if it doesn't exist
mkdir -p "$DIRECTORY"

# Find the highest existing screenshot number
LAST_NUMBER=$(ls "$DIRECTORY/$BASE_FILENAME"*.png 2>/dev/null | \
              grep -oE '[0-9]+' | \
              sort -n | \
              tail -n1)

# Set the next number
if [ -z "$LAST_NUMBER" ]; then
    NEXT_NUMBER=1
else
    NEXT_NUMBER=$((LAST_NUMBER + 1))
fi

# Define the output filename
OUTPUT_FILE="$DIRECTORY/$BASE_FILENAME$NEXT_NUMBER.$FILE_EXTENSION"

# Check if DISPLAY environment variable is set (necessary for X11)
if [ -z "$DISPLAY" ]; then
    echo "Error: DISPLAY environment variable is not set. Are you running X11?"
    exit 1
fi

# Take the screenshot using maim and slurp to select region
maim -s "$(slurp)" "$OUTPUT_FILE"
