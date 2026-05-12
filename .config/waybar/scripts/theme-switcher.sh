#!/usr/bin/env bash
# Cycles waybar themes by overwriting style.css with the next style-*.css file.
# Waybar's reload_style_on_change picks up the change automatically.

WAYBAR_DIR="$(cd "$(dirname "$0")/.." && pwd)"
STATE_FILE="$WAYBAR_DIR/.current-theme"

# Collect all theme files sorted alphabetically
mapfile -t themes < <(find -L "$WAYBAR_DIR" -maxdepth 1 -name 'style-*.css' | sort)

if [[ ${#themes[@]} -eq 0 ]]; then
    echo '{"text": "No themes", "tooltip": "No style-*.css files found"}'
    exit 0
fi

# Read current theme
current=""
[[ -f "$STATE_FILE" ]] && current=$(cat "$STATE_FILE")

# Find current index
current_idx=-1
for i in "${!themes[@]}"; do
    if [[ "${themes[$i]}" == "$current" ]]; then
        current_idx=$i
        break
    fi
done

case "${1:-}" in
    --next)
        # Cycle to next theme
        next_idx=$(( (current_idx + 1) % ${#themes[@]} ))
        next="${themes[$next_idx]}"
        cp "$next" "$WAYBAR_DIR/style.css"
        echo "$next" > "$STATE_FILE"
        ;;
    *)
        # Output current theme name for waybar display
        if [[ -n "$current" && -f "$current" ]]; then
            name=$(basename "$current" .css)
            name="${name#style-}"
        else
            # No state yet — detect from first theme or fallback
            name="unknown"
        fi
        echo "{\"text\": \"󰏘\", \"tooltip\": \"Theme: $name\nClick to switch\", \"class\": \"theme-switcher\"}"
        ;;
esac
