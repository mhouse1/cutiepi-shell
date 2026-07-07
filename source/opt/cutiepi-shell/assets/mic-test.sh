#!/bin/bash
# Factory-mode hardware test (FactoryMode.qml): records a few seconds of mic input and plays
# it back so a technician can confirm mic and speaker both work. Manual/human-verified pass-fail
# (listen to the playback) - not something CI can run unattended.
set -eu

SOURCE_INDEX="$(pactl get-default-source)"
ORIGINAL_VOLUME="$(pactl get-source-volume "$SOURCE_INDEX" | grep -oP '\d+%' | head -1)"
TMP_FILE="$(mktemp --suffix=.wav)"
trap 'pactl -- set-source-volume "$SOURCE_INDEX" "$ORIGINAL_VOLUME"; rm -f "$TMP_FILE"' EXIT

pactl -- set-source-volume "$SOURCE_INDEX" 240%
arecord -d 3 -f cd > "$TMP_FILE"
paplay "$TMP_FILE"
