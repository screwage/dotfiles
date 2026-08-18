#!/usr/bin/env bash
SUNSHINE_CONF="$HOME/.config/sunshine/sunshine.conf"
TARGET_WS=9
ORIGINAL_WS="$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused).name')"
HEADLESS_DISPLAY=

cleanup() {
    if [[ -n "$HEADLESS_DISPLAY" ]]; then
        swaymsg output "$HEADLESS_DISPLAY" unplug
        HEADLESS_DISPLAY=
    fi
}
trap cleanup EXIT

swaymsg create_output
HEADLESS_DISPLAY="$(swaymsg -t get_outputs | jq -r '.[] | .name' | grep HEADLESS)"

awk -v hd="$HEADLESS_DISPLAY" '
    BEGIN { found = 0 }
    /^output_name/ { print "output_name = " hd; found = 1; next }
    { print }
    END { if (!found) print "output_name = " hd }
' "$SUNSHINE_CONF" > "$SUNSHINE_CONF.tmp" && mv "$SUNSHINE_CONF.tmp" "$SUNSHINE_CONF"

swaymsg output $HEADLESS_DISPLAY mode 1920x1080@60Hz position -- '-1920' '0'

swaymsg workspace $TARGET_WS
swaymsg "move workspace to $HEADLESS_DISPLAY"
swaymsg workspace $ORIGINAL_WS

sunshine
