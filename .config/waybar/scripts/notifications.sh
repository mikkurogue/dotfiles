#!/usr/bin/env bash

# Waybar Dunst Notification Counter
# Shows notification count from dunst with configurable mode

MODE="${1:-active}"  # Default to 'active', can pass 'history' as argument

# Function to get notification counts
get_count() {
    local count_output
    count_output=$(dunstctl count 2>/dev/null)
    
    if [[ -z "$count_output" ]]; then
        echo 0
        return
    fi
    
    case "$MODE" in
        history)
            # Get history count
            echo "$count_output" | awk '/History:/ {print $2}'
            ;;
        active|*)
            # Get waiting + displayed count (active notifications)
            local waiting displayed
            waiting=$(echo "$count_output" | awk '/Waiting/ {print $NF}')
            displayed=$(echo "$count_output" | awk '/displayed/ {print $NF}')
            # Default to 0 if empty
            waiting=${waiting:-0}
            displayed=${displayed:-0}
            echo $((waiting + displayed))
            ;;
    esac
}

# Get the count
COUNT=$(get_count)

# Determine icon and class based on count
if [[ "$COUNT" -gt 0 ]]; then
    ICON="󰂚"
    CLASS="active"
    TEXT="$ICON $COUNT"
    TOOLTIP="$COUNT unread notification(s)"
else
    ICON="󰂛"
    CLASS="empty"
    TEXT="$ICON"
    TOOLTIP="No notifications"
fi

# Output JSON for Waybar
echo "{\"text\":\"$TEXT\",\"tooltip\":\"$TOOLTIP\",\"class\":\"$CLASS\"}"
