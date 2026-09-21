#!/usr/bin/env bash

LG_SERIAL="605BNYM2V770"
SAMSUNG_SERIAL="HNAL505694"

OUTPUT="$(gdctl show)"

LG=$(awk -v serial="$LG_SERIAL" '
  /^├──Monitor |^└──Monitor / {connector=$2}
  $0 ~ "Serial: " serial {print connector}
' <<< "$OUTPUT")

SAMSUNG=$(awk -v serial="$SAMSUNG_SERIAL" '
  /^├──Monitor |^└──Monitor / {connector=$2}
  $0 ~ "Serial: " serial {print connector}
' <<< "$OUTPUT")

if [[ -z "$LG" || -z "$SAMSUNG" ]]; then
    echo "Dock monitors not both detected."
    exit 1
fi

gdctl set --persistent \
  --logical-monitor --monitor "$SAMSUNG" --transform 270 --x 0 --y 0 \
  --logical-monitor --monitor "$LG" --primary --transform normal --x 1440 --y 625
