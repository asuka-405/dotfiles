#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/images"
  exit 1
fi

IMAGE_DIR="$1"

if [ ! -d "$IMAGE_DIR" ]; then
  echo "Directory $IMAGE_DIR does not exist."
  exit 1
fi

# List all image files in the directory
IMAGE_LIST=$(find "$IMAGE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | sort)

if [ -z "$IMAGE_LIST" ]; then
  echo "No images found in $IMAGE_DIR."
  exit 1
fi

# File to store the current wallpaper
CURRENT_IMAGE_FILE="$HOME/.current_wallpaper"

# Get the current wallpaper or set the first image if the file doesn't exist
if [ -f "$CURRENT_IMAGE_FILE" ]; then
  CURRENT_IMAGE=$(cat "$CURRENT_IMAGE_FILE")
else
  CURRENT_IMAGE=""
fi

# Find the next image in the list
NEXT_IMAGE=""
FOUND_CURRENT=false
for IMAGE in $IMAGE_LIST; do
  if [ "$FOUND_CURRENT" = true ]; then
    NEXT_IMAGE="$IMAGE"
    break
  fi
  if [ "$IMAGE" = "$CURRENT_IMAGE" ]; then
    FOUND_CURRENT=true
  fi
done

# If no next image is found, loop back to the first one
if [ -z "$NEXT_IMAGE" ]; then
  NEXT_IMAGE=$(echo "$IMAGE_LIST" | head -n 1)
fi

# Set the wallpaper and save the current image
feh --bg-fill "$NEXT_IMAGE"
echo "$NEXT_IMAGE" > "$CURRENT_IMAGE_FILE"

echo "Wallpaper set to: $NEXT_IMAGE"

