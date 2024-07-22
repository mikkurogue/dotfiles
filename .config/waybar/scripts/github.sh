#!/bin/bash

# Replace <MY TOKEN> with your actual token or use an environment variable
GITHUB_TOKEN="<MY TOKEN>"

# Get the notification count
count=$(curl -u mikkurogue:$GITHUB_TOKEN -s https://api.github.com/notifications | jq '. | length')

# Debugging: Print the count to a log file
echo "Notification count: $count" >> /tmp/github_waybar.log

# Generate the JSON output
if [[ "$count" != "0" ]]; then
    echo "{\"text\": \"$count \", \"tooltip\": \"$count\" unread notifications, \"class\": \"github-notify\"}"
else
    echo "{\"text\": \"0 \", \"tooltip\": \"No new notifications\", \"class\": \"github-none\"}"
fi
