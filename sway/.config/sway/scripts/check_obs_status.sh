#!/usr/bin/env bash
# Utility script to debug current OBS state

OBS_WS=10
OBS_HEADLESS_WS=1337
STATE_FILE="/tmp/sway_obs_headless_output"

echo "=== OBS Status Check ==="

# Check if OBS is running
OBS_ID=$(swaymsg -t get_tree | jq -r '.. | select(.window_properties?.class == "obs") | .id' | head -1)
if [ -n "$OBS_ID" ]; then
    echo "OBS is running (ID: $OBS_ID)"
    
    # Find which workspace OBS is on
    OBS_WORKSPACE=$(swaymsg -t get_tree | jq -r ".. | select(.id == $OBS_ID) | .workspace // empty" | head -1)
    echo "OBS is on workspace: $OBS_WORKSPACE"
else
    echo "OBS is not running"
fi

# Check stored headless output
if [ -f "$STATE_FILE" ]; then
    STORED_OUTPUT=$(cat "$STATE_FILE")
    echo "Stored headless output: $STORED_OUTPUT"
    
    if swaymsg -t get_outputs | jq -e --arg output "$STORED_OUTPUT" '.[] | select(.name == $output)' >/dev/null 2>&1; then
        echo "Stored headless output exists"
    else
        echo "Stored headless output no longer exists"
    fi
else
    echo "No stored headless output"
fi

# List all headless outputs
echo "All headless outputs:"
swaymsg -t get_outputs | jq -r '.[] | select(.name | startswith("HEADLESS-")) | .name' | while read output; do
    echo "  - $output"
done

# Show current workspace
CURRENT_WS=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')
echo "Current workspace: $CURRENT_WS"
