if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/images"
  exit 1
fi

IMAGE_DIR="$1"

if [ ! -d "$IMAGE_DIR" ]; then
  echo "Directory $IMAGE_DIR does not exist."
  exit 1
fi

IMAGE_LIST=$(find "$IMAGE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \))

if [ -z "$IMAGE_LIST" ]; then
  echo "No images found in $IMAGE_DIR."
  exit 1
fi

SELECTED_IMAGE=$(echo "$IMAGE_LIST" | shuf -n 1)

feh --bg-fill "$SELECTED_IMAGE"

echo "Wallpaper set to: $SELECTED_IMAGE"

