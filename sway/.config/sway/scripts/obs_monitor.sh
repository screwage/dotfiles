#!/usr/bin/env bash
# Continuously monitors for OBS and cleans up when it closes

OBS_HEADLESS_WS=1337
STATE_FILE="/tmp/sway_obs_headless_output"
PID_FILE="/tmp/sway_obs_monitor.pid"

# Function to cleanup
cleanup_obs() {
    echo "OBS closed, cleaning up..."
    
    # Get the stored headless output name
    if [ -f "$STATE_FILE" ]; then
        HEADLESS_OUTPUT=$(cat "$STATE_FILE")
        
        # Remove any remaining windows from workspace 1337
        swaymsg "[workspace=\"$OBS_HEADLESS_WS\"] kill" 2>/dev/null
        
        # Focus away from headless output
        if [ -n "$HEADLESS_OUTPUT" ]; then
            swaymsg output "$HEADLESS_OUTPUT" unplug
            dunstify -t 1250 "OBS Cleanup" "Headless Display Unplugged"
        fi
        
        # Remove the state file
        rm -f "$STATE_FILE"
    fi
    
    # Remove PID file
    rm -f "$PID_FILE"
}

# Kill any existing monitor
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    kill "$OLD_PID" 2>/dev/null
fi

# Store our PID
echo $ > "$PID_FILE"

# Monitor loop
while true; do
    sleep 5
    
    # Check if OBS is still running
    OBS_RUNNING=$(swaymsg -t get_tree | jq -r '.. | select(.window_properties?.class == "obs") | .id' | head -1)
    
    if [ -z "$OBS_RUNNING" ]; then
        # OBS is no longer running
        cleanup_obs
        exit 0
    fi
done
