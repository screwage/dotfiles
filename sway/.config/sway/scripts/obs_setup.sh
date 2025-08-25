#!/usr/bin/env bash
# Creates headless output and sets up OBS workspace

PRIMARY_OUTPUT="DP-1"
OBS_HEADLESS_WS=1337
STATE_FILE="/tmp/sway_obs_headless_output"

# Function to get our headless output name
get_headless_output() {
    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        echo ""
    fi
}

# Function to find any existing headless output we might be using
find_existing_headless() {
    # Look for any HEADLESS-* output that has workspace 1337
    swaymsg -t get_outputs | jq -r '.[] | select(.name | startswith("HEADLESS-")) | .name' | while read output; do
        if swaymsg -t get_workspaces | jq -e --arg output "$output" '.[] | select(.output == $output and .name == "1337")' >/dev/null 2>&1; then
            echo "$output"
            return
        fi
    done
}

EXISTING_OUTPUT=$(find_existing_headless)
STORED_OUTPUT=$(get_headless_output)

if [ -n "$EXISTING_OUTPUT" ]; then
    # We found an existing headless output with workspace 1337
    HEADLESS_OUTPUT="$EXISTING_OUTPUT"
    echo "$HEADLESS_OUTPUT" > "$STATE_FILE"
elif [ -n "$STORED_OUTPUT" ] && swaymsg -t get_outputs | jq -e --arg output "$STORED_OUTPUT" '.[] | select(.name == $output)' >/dev/null 2>&1; then
    # Our stored output still exists
    HEADLESS_OUTPUT="$STORED_OUTPUT"
else
    # Need to create new headless output
    swaymsg create_output
    sleep 0.5
    
    # Find the newest HEADLESS-* output (highest number)
    HEADLESS_OUTPUT=$(swaymsg -t get_outputs | jq -r '.[] | select(.name | startswith("HEADLESS-")) | .name' | sort -V | tail -1)
    
    if [ -z "$HEADLESS_OUTPUT" ]; then
        echo "Failed to create or find headless output"
        exit 1
    fi
    
    # Store the output name for future use
    echo "$HEADLESS_OUTPUT" > "$STATE_FILE"

    # Position headless output away from cursor path (far right and down)
    swaymsg output "$HEADLESS_OUTPUT" pos 9999 9999
    
    # Set up workspace 1337 on the headless output
    # swaymsg focus output "$HEADLESS_OUTPUT"
    swaymsg workspace --no-auto-back-and-forth "$OBS_HEADLESS_WS output $HEADLESS_OUTPUT"

    # Assign workspace 1337 to headless output
    # Create a dummy window on workspace 1337 to claim the headless output
    swaymsg "workspace $OBS_HEADLESS_WS output $HEADLESS_OUTPUT"
    # Return focus to main output
    swaymsg focus output "$PRIMARY_OUTPUT"
fi

# Ensure workspace 1337 exists on headless output
swaymsg "[output=\"$HEADLESS_OUTPUT\"] workspace $OBS_HEADLESS_WS"



















# # Creates headless output and sets up OBS workspace
#
# HEADLESS_OUTPUT="HEADLESS-OBS"
# OBS_HEADLESS_WS=1337
#
# # Check if headless output already exists
# if ! swaymsg -t get_outputs | grep -q "$HEADLESS_OUTPUT"; then
#     # Create headless output
#     swaymsg create_output "$HEADLESS_OUTPUT"
#     sleep 0.5
#
#     # Move headless output to workspace 1337
#     swaymsg focus output "$HEADLESS_OUTPUT"
#     swaymsg workspace $OBS_HEADLESS_WS
#
#     # Return focus to main output
#     swaymsg focus output primary
# fi
#
# # Ensure workspace 1337 exists on headless output
# swaymsg "[output=\"$HEADLESS_OUTPUT\"] workspace $OBS_HEADLESS_WS"
