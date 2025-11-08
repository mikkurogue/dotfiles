#!/bin/sh

# This script gets the current keyboard layout and formats it for Waybar.

layout=$(hyprctl devices -j | jq -r '.keyboards[0].active_keymap' | cut -d ' ' -f 1)

# Truncate to 2 characters and convert to uppercase (e.g., "Finnish" -> "FI")
layout_short=$(echo "$layout" | cut -c 1-2 | tr 'a-z' 'A-Z')

echo "{\"text\": \"$layout_short\"}"
