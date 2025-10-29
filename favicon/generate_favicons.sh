#!/usr/bin/env bash

# Make the script stop if something goes wrong:
# -e: any command fails
# -u: unset variable is used
# -o pipefail: a pipeline fails if any command fails
set -euo pipefail

# Show a clear error before exiting
trap 'echo -e "\033[1;31mError at line $LINENO\033[0m" >&2; exit 1' ERR

# =================================== CONFIG ===================================

# Paths
SRC_SVG="$(dirname "$BASH_SOURCE[0]")/artwork/logo.svg"
OUTPUT_DIR="$(dirname "$BASH_SOURCE[0]")/../static"

# Cropping
CROP_SIZE=800  # final square viewBox size (e.g., 800x800)

# Branding / Manifest (for site.webmanifest)
APP_NAME="Little Emulator"
THEME_COLOR="#000000"
BACKGROUND_COLOR="#000000"

# Dark variant color swap (case-insensitive)
COLOR_A="#36373b"
COLOR_B="#fafcfc"

# Raster outputs
#  size       file_name       background
PNG_LIST=(
  "192  android-chrome-192x192.png  none"
  "512  android-chrome-512x512.png  none"
  "180  apple-touch-icon.png        white"
  "16   favicon-16x16.png           none"
  "32   favicon-32x32.png           none"
)

# ICO sizes
ICO_SIZES=(16 32 48)

# ============================= Pre-flight checks ==============================

[[ -f "${SRC_SVG}" ]] || { echo "\033[1;31mError: Source SVG not found: ${SRC_SVG}\033[0m" >&2; exit 1; }
command -v magick >/dev/null     || { echo "\033[1;31mError: ImageMagick (magick) not found\033[0m" >&2; exit 1; }
command -v xmlstarlet >/dev/null || { echo "\033[1;31mError: xmlstarlet required for SVG cropping\033[0m" >&2; exit 1; }

# ================================= Functions ==================================

##############################################
# crop_svg_viewbox <input.svg> <output.svg> <target_size>
# Rewrites the SVG viewBox to a centered square
##############################################
crop_svg_viewbox() {
  local INPUT_FILE="$1"
  local OUTPUT_FILE="$2"
  local TARGET_SIZE="$3"

  local VIEWBOX MIN_X MIN_Y VIEWBOX_WIDTH VIEWBOX_HEIGHT
  local NEW_MIN_X NEW_MIN_Y NEW_SIZE

  # Normalize: if no viewBox, derive it from width/height (viewBox="0 0 w h")
  VIEWBOX="$(xmlstarlet sel -t -v "string(/*[local-name()='svg']/@viewBox)" "$INPUT_FILE" || :)"
  if [[ $VIEWBOX =~ [^[:space:]] ]]; then
    read -r MIN_X MIN_Y VIEWBOX_WIDTH VIEWBOX_HEIGHT <<<"$(tr ',' ' ' <<<"$VIEWBOX")"
  else
    VIEWBOX_WIDTH="$(xmlstarlet sel -t -v "string(/*[local-name()='svg']/@width)"  "$INPUT_FILE")"
    VIEWBOX_HEIGHT="$(xmlstarlet sel -t -v "string(/*[local-name()='svg']/@height)" "$INPUT_FILE")"
    VIEWBOX_WIDTH="${VIEWBOX_WIDTH//[!0-9.+-]/}"
    VIEWBOX_HEIGHT="${VIEWBOX_HEIGHT//[!0-9.+-]/}"
    MIN_X=0
    MIN_Y=0
    VIEWBOX="$MIN_X $MIN_Y $VIEWBOX_WIDTH $VIEWBOX_HEIGHT"
  fi

  # Compute centered square
  read -r NEW_MIN_X NEW_MIN_Y NEW_SIZE < <(awk "
    BEGIN {
      SIDE = ($VIEWBOX_WIDTH < $TARGET_SIZE ? $VIEWBOX_WIDTH : $TARGET_SIZE)
      if ($VIEWBOX_HEIGHT < SIDE) SIDE = $VIEWBOX_HEIGHT
      CENTER_X = $MIN_X + ($VIEWBOX_WIDTH - SIDE) / 2.0
      CENTER_Y = $MIN_Y + ($VIEWBOX_HEIGHT - SIDE) / 2.0
      print CENTER_X, CENTER_Y, SIDE
    }
  ")

  # Apply normalized centered square viewBox, remove width/height, enforce centered rendering
  xmlstarlet ed \
    --update "/*[local-name()='svg']/@viewBox" -v "$NEW_MIN_X $NEW_MIN_Y $NEW_SIZE $NEW_SIZE" \
    --insert "/*[local-name()='svg'][not(@viewBox)]" \
    --type attr --name "viewBox" --value "$NEW_MIN_X $NEW_MIN_Y $NEW_SIZE $NEW_SIZE" \
    \
    --delete "/*[local-name()='svg']/@width" \
    --delete "/*[local-name()='svg']/@height" \
    --update "/*[local-name()='svg']/@preserveAspectRatio" -v "xMidYMid meet" \
    "$INPUT_FILE" > "$OUTPUT_FILE"
}

##############################################
# render_png <width> <height> <out_path> <background|'none'>
##############################################
render_png() {
  local SIZE="$1" INPUT="$2" OUTPUT="$3" BACKGROUND_COLOR="${4:-none}"

  magick -density 384 "${INPUT}" \
    -background "${BACKGROUND_COLOR}" -alpha remove -alpha off \
    -resize "${SIZE}x${SIZE}" -gravity center -extent "${SIZE}x${SIZE}" \
    -strip "${OUTPUT}"
}

# ==================================== Main ====================================

mkdir -p "${OUTPUT_DIR}"

echo "▶️  Cropping SVG to centered ${CROP_SIZE}x${CROP_SIZE} viewBox…"
crop_svg_viewbox "${SRC_SVG}" "${OUTPUT_DIR}/favicon.svg" "${CROP_SIZE}"
echo "✅ Cropped vector saved: favicon.svg"

echo "▶️  Creating dark SVG variant by swapping ${COLOR_A} and ${COLOR_B}..."
sed -E \
    -e "s/${COLOR_A//\#/\\#}/__TMP_COLOR__/Ig" \
    -e "s/${COLOR_B//\#/\\#}/${COLOR_A//\#/\\#}/Ig" \
    -e "s/__TMP_COLOR__/${COLOR_B//\#/\\#}/Ig" \
    "${OUTPUT_DIR}/favicon.svg" > "${OUTPUT_DIR}/favicon-dark.svg"
echo "✅ Dark variant saved: favicon-dark.svg"

echo "▶️  Rendering PNG assets..."
for ITEM in "${PNG_LIST[@]}"; do
  read -r SIZE NAME BG <<<"$ITEM"
  render_png "$SIZE" "${OUTPUT_DIR}/favicon.svg" "${OUTPUT_DIR}/${NAME}" "${BG}"
  echo "   • ${NAME} (${SIZE}px)"
done
echo "✅ PNGs done."

echo "▶️  Building multi-size ICO..."
TMP_PNG_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_PNG_DIR}"' EXIT
ICO_INPUTS=()
for SIZE in "${ICO_SIZES[@]}"; do
  render_png "$SIZE" "${OUTPUT_DIR}/favicon.svg" "${TMP_PNG_DIR}/${SIZE}.png" "none"
  ICO_INPUTS+=("${TMP_PNG_DIR}/${SIZE}.png")
done
magick "${ICO_INPUTS[@]}" -colors 256 "${OUTPUT_DIR}/favicon.ico"
echo "✅ ICO saved: favicon.ico"

echo "▶️  Writing site.webmanifest..."
ICON_ITEMS=()
for ITEM in "${PNG_LIST[@]}"; do
  read -r SIZE NAME BG <<<"$ITEM"
  [[ "$NAME" == android-* ]] || continue

  ITEM='{ "src": "/'"$NAME"'", "sizes": "'"$SIZE"'x'"$SIZE"'", "type": "image/png" }'
  ICON_ITEMS+=("$ITEM")
done
ICON_JSON="$(printf '%s\n' "${ICON_ITEMS[@]}" | paste -sd, -)"
cat > "${OUTPUT_DIR}/site.webmanifest" << JSON
{
  "name": "${APP_NAME}",
  "short_name": "${APP_NAME}",
  "icons": [ ${ICON_JSON} ],
  "theme_color": "${THEME_COLOR}",
  "background_color": "${BACKGROUND_COLOR}",
  "display": "standalone"
}
JSON
echo "✅ Manifest saved: site.webmanifest"

echo "🎉 All assets written to: $(readlink -f "$OUTPUT_DIR")"
