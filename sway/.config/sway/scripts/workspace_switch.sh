#!/bin/bash
# Handles workspace switching with OBS management

PRIMARY_OUTPUT="DP-1"
TARGET_WS=$1
OBS_WS=10
OBS_HEADLESS_WS=1337
STATE_FILE="/tmp/sway_obs_headless_output"

# Get the stored headless output name
if [ -f "$STATE_FILE" ]; then
    HEADLESS_OUTPUT=$(cat "$STATE_FILE")
else
    HEADLESS_OUTPUT=""
fi

# Check if OBS is running
OBS_RUNNING=$(swaymsg -t get_tree | jq -r '.. | select(.window_properties?.class == "obs") | .id' | head -1)

if [ -n "$OBS_RUNNING" ]; then
    if [ "$TARGET_WS" = "$OBS_WS" ]; then
        # Switching TO OBS workspace - move OBS back from headless
        swaymsg "[class=\"^obs$\"] move container to workspace $OBS_WS"
        swaymsg workspace $TARGET_WS
    else
        # Switching AWAY from OBS workspace - move OBS to headless
        CURRENT_WS=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')
        
        if [ "$CURRENT_WS" = "$OBS_WS" ]; then
            # We're currently on OBS workspace, move OBS to headless before switching
            swaymsg "[class=\"^obs$\"] move container to workspace $OBS_HEADLESS_WS, move container to output $HEADLESS_OUTPUT"
        fi
        
        swaymsg workspace $TARGET_WS
        # Hack to fix workspaces being set to headless output
        swaymsg "move workspace to $PRIMARY_OUTPUT"
    fi
else
    # No OBS running, normal workspace switch
    swaymsg workspace $TARGET_WS
fi







#
# # Handles workspace switching with OBS management
#
# TARGET_WS=$1
# OBS_WS=10
# OBS_HEADLESS_WS=1337
# HEADLESS_OUTPUT="HEADLESS-OBS"
#
# # Check if OBS is running
# OBS_RUNNING=$(swaymsg -t get_tree | jq -r '.. | select(.window_properties?.class == "obs") | .id' | head -1)
#
# if [ -n "$OBS_RUNNING" ]; then
#     if [ "$TARGET_WS" = "$OBS_WS" ]; then
#         # Switching TO OBS workspace - move OBS back from headless
#         swaymsg "[app_id=\"com.obsproject.Studio\"] move container to workspace $OBS_WS"
#         swaymsg workspace $TARGET_WS
#     else
#         # Switching AWAY from OBS workspace - move OBS to headless
#         CURRENT_WS=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')
#
#         if [ "$CURRENT_WS" = "$OBS_WS" ]; then
#             # We're currently on OBS workspace, move OBS to headless before switching
#             swaymsg "[class=\"obs\"] move container to workspace $OBS_HEADLESS_WS, move container to output $HEADLESS_OUTPUT"
#         fi
#
#         swaymsg workspace $TARGET_WS
#     fi
# else
#     # No OBS running, normal workspace switch
#     swaymsg workspace $TARGET_WS
# fi
