#!/usr/bin/env bash
# Renders page 1 of a PDF as a sheet with a drop shadow, for use as a README
# thumbnail. A document of more than one page gets a second sheet stacked
# behind the first, which reads as "there is more than one page here". The
# stack does not track the exact page count.
#
#   1 page           a single sheet
#   2 or more        one sheet behind
#
# The PDF is rasterised with pdftoppm rather than by ImageMagick, because most
# distributions ship a policy file that stops ImageMagick reading PDFs at all.
#
# usage: tools/mkthumb.sh <input.pdf> <output.png> [display-width]

set -euo pipefail

pdf=$1
out=$2
width=$(( ${3:-220} * 2 ))   # rendered at 2x, shown at 1x in the README
edge='#d8dee4'               # page border
step=16                      # offset between stacked sheets, at 2x

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

pages=$(pdfinfo "$pdf" | awk '/^Pages:/ {print $2}')
if [ "$pages" -ge 2 ]; then back=1
else                        back=0
fi

pdftoppm -png -r 200 -f 1 -l $(( back + 1 )) "$pdf" "$tmp/p"

sheet () {   # sheet <page.png> <sheet.png>
  convert "$1" -resize "${width}x" -bordercolor "$edge" -border 1 \
    \( +clone -background black -shadow 55x10+0+4 \) \
    +swap -background none -layers merge +repage "$2"
}

n=0
for page in "$tmp"/p-*.png; do
  sheet "$page" "$tmp/s$n.png"
  n=$(( n + 1 ))
done

if [ "$back" -eq 0 ]; then
  convert "$tmp/s0.png" -colors 96 -strip "$out"
else
  args=()
  for (( k = back; k >= 1; k-- )); do
    args+=( "$tmp/s$k.png" -geometry "+$(( k * step ))+$(( k * step ))" -composite )
  done
  args+=( "$tmp/s0.png" -geometry '+0+0' -composite )

  w=$(identify -format '%w' "$tmp/s0.png")
  h=$(identify -format '%h' "$tmp/s0.png")
  convert -size "$(( w + back * step ))x$(( h + back * step ))" xc:none \
    "${args[@]}" -colors 96 -strip "$out"
fi

printf '%s  %s pages  %s px  %s\n' \
  "$out" "$pages" "$(identify -format '%wx%h' "$out")" \
  "$(du -h "$out" | cut -f1)"
