#!/bin/sh
# This script dynamically finds all connected keyboards and switches their layout.
# It requires `jq` to be installed to parse the output of `hyprctl`.

hyprctl devices -j | jq -r '.keyboards[] | .name' | while read -r keyboard_name; do
    hyprctl switchxkblayout "$keyboard_name" next
done
