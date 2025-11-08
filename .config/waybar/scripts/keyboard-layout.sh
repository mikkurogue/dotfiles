#!/bin/bash
hyprctl -j devices | jq -r '.keyboards[] | select(.main == true) | .active_keymap'
