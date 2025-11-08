#!/bin/bash

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo '{"text": "", "tooltip": "gh CLI not installed", "class": "disabled"}'
    exit 0
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo '{"text": "", "tooltip": "Not authenticated with GitHub", "class": "disabled"}'
    exit 0
fi

# Get notification count
NOTIF_COUNT=$(gh api notifications --jq 'length' 2>/dev/null)

if [ -z "$NOTIF_COUNT" ] || [ "$NOTIF_COUNT" -eq 0 ]; then
    echo '{"text": " ", "tooltip": "No new notifications", "class": "empty"}'
else
    # Get details for tooltip
    TOOLTIP=$(gh api notifications --jq '.[] | "• \(.subject.title) (\(.repository.full_name))"' 2>/dev/null | head -n 10)
    if [ $(echo "$TOOLTIP" | wc -l) -lt $NOTIF_COUNT ]; then
        TOOLTIP="${TOOLTIP}\n... and $((NOTIF_COUNT - 10)) more"
    fi
    
    echo "{\"text\": \"$NOTIF_COUNT\", \"tooltip\": \"GitHub Notifications ($NOTIF_COUNT):\n$TOOLTIP\", \"class\": \"notifications\"}"
fi
