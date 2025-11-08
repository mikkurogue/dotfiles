# Dotfiles

My personal configuration files for Hyprland desktop environment.

## Contents

- **waybar** - Status bar configuration
- **nvim** - Neovim configuration
- **hypr** - Hyprland window manager configuration
- **ghostty** - Ghostty terminal emulator configuration
- **starship.toml** - Starship prompt configuration
- **zsh** - Zsh shell configuration and plugins
  - `.zshrc` - Zsh configuration file
  - `zsh-syntax-highlighting` - Syntax highlighting plugin
- **fish** - Fish shell configuration (feature parity with Zsh)
  - `config.fish` - Fish configuration file
  - `functions/cd.fish` - Custom cd function with zoxide integration

## Theme

All configurations are hardcoded with the **Tokyo Night** color scheme for consistency across Hyprland, Waybar, and Hyprlock.

## Installation

### Quick Install (Fresh Arch System)

```bash
# Clone the repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Install all dependencies (requires yay or will install it)
./install.sh

# Setup dotfiles (create symlinks)
./setup.sh

# Log out and log back in for shell changes to take effect
```

### Manual Installation

If you prefer to install components manually:

```bash
# Clone the repository
git clone <your-repo-url> ~/dotfiles

# Create symlinks (backup your existing configs first!)
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/.config/waybar ~/.config/waybar
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.config/hypr ~/.config/hypr
ln -sf ~/dotfiles/.config/ghostty ~/.config/ghostty
ln -sf ~/dotfiles/.config/fish ~/.config/fish
```

## Shell Options

This dotfiles repository supports both **Zsh** and **Fish** shells with feature parity.

### Switching Between Shells

To try Fish temporarily:
```bash
fish
```

To switch default shell to Fish:
```bash
chsh -s $(which fish)
```

To switch back to Zsh:
```bash
chsh -s $(which zsh)
```

See `DEPENDENCIES.md` for a complete list of required packages.

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
- **Omarchy defaults**: The `defaults/` directory contains copies of Omarchy's default configurations. See `.config/hypr/defaults/README.md` for details about replacing omarchy-specific commands if you don't have Omarchy installed.
