# Dotfiles

My personal configuration files for Hyprland desktop environment.

## Contents

- **waybar** - Status bar configuration
- **nvim** - Neovim configuration
- **hypr** - Hyprland window manager configuration
- **zsh** - Zsh shell configuration and plugins
  - `.zshrc` - Zsh configuration file
  - `zsh-syntax-highlighting` - Syntax highlighting plugin

## Installation

```bash
# Clone the repository
git clone <your-repo-url> ~/dotfiles

# Create symlinks (backup your existing configs first!)
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.config/waybar ~/.config/waybar
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.config/hypr ~/.config/hypr
```

## Special Scripts

### Waybar Scripts
- `github-notifications.sh` - GitHub notifications integration
- `keyboard-layout.sh` - Keyboard layout display
- `kb-layout-switch.sh` - Switch keyboard layouts
- `get-kb-layout.sh` - Get current keyboard layout

### Hypr Scripts
- `get-kb-layout.sh` - Keyboard layout helper
- `kb-layout-switch.sh` - Layout switching utility
- `github-notifications.sh` - Notifications
- `keyboard-layout.sh` - Layout indicator

## Notes

- Make sure to review and adjust paths in configuration files after installation
- Some scripts may require additional dependencies
