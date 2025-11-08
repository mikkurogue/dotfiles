# Omarchy Defaults

The `omarchy-defaults/` directory contains copies of the default configuration files from Omarchy.

These files have been copied locally to make this dotfiles repository standalone and independent of the Omarchy installation.

## Notes

- All path references have been updated to point to local files
- Some omarchy-specific commands remain in the files (like `omarchy-launch-browser`, `omarchy-menu`, etc.)
- If you don't have Omarchy installed, you may need to replace these commands with alternatives
- The wallpaper path in `autostart.conf` has been commented out - set your own wallpaper

## Omarchy Commands Used

If you want to replace omarchy commands with alternatives:
- `omarchy-launch-browser` → your preferred browser
- `omarchy-launch-editor` → your preferred editor  
- `omarchy-menu` → rofi/wofi/walker
- `omarchy-launch-webapp` → browser with webapp mode
- `omarchy-cmd-screenshot` → grim/hyprshot
- etc.
