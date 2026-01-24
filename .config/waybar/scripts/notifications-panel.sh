#!/usr/bin/env bash

# Waybar Dunst Notification Panel
# Opens wofi menu with notification list and actions

# Function to parse dunst history and format for wofi
get_notifications() {
    local history_json
    history_json=$(dunstctl history 2>/dev/null)
    
    if [[ -z "$history_json" ]]; then
        echo ""
        return
    fi
    
    # Parse JSON and create menu entries
    # Format: [ID] App: Summary
    echo "$history_json" | jq -r '
        .data[0] // [] | 
        to_entries | 
        reverse |
        .[] | 
        .value as $notif |
        ($notif.id.data | tostring) + "|" + 
        ($notif.appname.data // "Unknown") + ": " + 
        ($notif.summary.data // "No title") + 
        (if ($notif.body.data // "") != "" then " - " + ($notif.body.data | .[0:50]) else "" end)
    ' 2>/dev/null
}

# Check if there are any notifications
NOTIFICATIONS=$(get_notifications)

if [[ -z "$NOTIFICATIONS" ]]; then
    # No notifications
    notify-send "Notifications" "No notifications to display" -u low
    exit 0
fi

# Build wofi menu with notifications + actions
MENU_ITEMS=$(cat <<EOF
  Clear All
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$NOTIFICATIONS
EOF
)

# Show wofi menu and get selection
SELECTION=$(echo "$MENU_ITEMS" | wofi --dmenu --prompt "Notifications" --width 600 --height 400 --style ~/.config/wofi/style.css 2>/dev/null)

# Handle selection
if [[ -z "$SELECTION" ]]; then
    # User dismissed the menu
    exit 0
elif [[ "$SELECTION" == " Clear All" ]]; then
    # Clear all notifications
    dunstctl history-clear
    # notify-send "Notifications" "All notifications cleared" -u low
elif [[ "$SELECTION" == "━"* ]]; then
    # Separator line, ignore
    exit 0
else
    # Extract notification ID from selection
    NOTIF_ID=$(echo "$SELECTION" | cut -d'|' -f1)
    
    if [[ -n "$NOTIF_ID" ]]; then
        # Get notification details for context menu
        NOTIF_DETAILS=$(dunstctl history | jq -r --arg id "$NOTIF_ID" '
            .data[0][] | 
            select(.id.data == ($id | tonumber)) |
            .appname.data + ": " + .summary.data + "\n" + .body.data
        ' 2>/dev/null | head -c 200)
        
        # Show action menu for this notification
        ACTION=$(echo -e "󰈙 View Details\n Clear This\n Trigger Action" | wofi --dmenu --prompt "Notification Action" --width 300 --height 150 2>/dev/null)
        
        case "$ACTION" in
            "󰈙 View Details")
                # notify-send "Notification Details" "$NOTIF_DETAILS" -u normal
                ;;
            " Clear This")
                dunstctl close "$NOTIF_ID"
                # notify-send "Notification" "Cleared notification #$NOTIF_ID" -u low
                ;;
            " Trigger Action")
                # Try to trigger the default action
                dunstctl action "$NOTIF_ID" default 2>/dev/null || notify-send "Action" "No default action available" -u low
                ;;
        esac
    fi
fi
