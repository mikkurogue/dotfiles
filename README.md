# Mikku's Dotfiles

Personal configuration files for CachyOS/Arch Linux with Hyprland and Niri window managers.

Note on nix; i am soon planning on creating a nixOS installation with these dotfiles. When I dont know but soon tm

```bash
# Clone this repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install all dependencies (Hyprland, Niri, tools, etc.)
./install.sh

# Symlink all configuration files
./setup.sh

# Reboot
sudo reboot
```

## 📦 What Gets Installed

### Window Managers & Compositors
- **Hyprland** - Dynamic tiling Wayland compositor
- **Niri** - Scrollable-tiling Wayland compositor
- **Vicinae** - App launcher

### Shell & Terminal
- **Fish** - Default shell
- **Zsh** - Alternative shell with plugins
- **Starship** - Cross-shell prompt
- **Ghostty** - Terminal emulator
- **Kitty** - Terminal emulator

### Development Tools
- **Neovim Nightly** - Text editor
- **Jujutsu (jj)** - Version control
- **Git** - Version control
- **GitHub CLI** - GitHub integration
- **Lazygit** - Git TUI
- **Rust & Cargo** - Rust toolchain
- **Zig** - Zig compiler
- **Go** - Go compiler

### Utilities
- **Waybar** - Status bar
- **SwayNC** - Notification center
- **SwayOSD** - On-screen display
- **Grim + Slurp** - Screenshots
- **Brightnessctl** - Brightness control
- **Playerctl** - Media control
- **Zoxide** - Smart cd
- **Eza** - Better ls
- **Bat** - Better cat
- **Fzf** - Fuzzy finder
- **Ripgrep** - Fast grep
- **Btop** - System monitor
- **Fastfetch** - System info
- **Kunai** - Input device configuration for locale swapping on the fly

### Desktop Apps
- **Firefox** - Web browser
- **Discord** - Chat
- **Dolphin** - File manager
- **Steam** - Gaming
- **Faugus Launcher** - Game launcher
- **Thunar** - File manager

### Gaming Support
- **Wine Staging** - Windows compatibility
- **AMD GPU drivers** - Full Vulkan/Mesa support
- **32-bit libraries** - For gaming compatibility

### Shell Aliases
Common aliases set in both Fish and Zsh:
- `ls` → `eza` with icons and colors
- `cd` → smart directory jumping with zoxide
- `cat` → `bat` with syntax highlighting
- `..` / `...` / `....` → quick parent navigation

## 🎮 Gaming Setup

Includes full AMD GPU support with:
- Vulkan drivers (64-bit & 32-bit)
- Mesa drivers
- Wine Staging
- Steam
- Faugus Launcher for managing game launchers

## ⌨️ Keyboard Setup

Vial WebHID udev rules for custom keyboard support automatically installed to `/etc/udev/rules.d/`.

## 🌐 Environment Variables

Created in `~/.config/environment.d/`:
- **Qt theming** - Uses qt6ct
- **Wine settings** - Integer scaling for games
- **Wayland support** - Force apps to use Wayland

## 🛠️ Customization

### Change default shell
```bash
chsh -s $(which fish)  # or $(which zsh)
```

### Update packages
```bash
yay -Syu
```

### Modify configs
All configs are symlinked from `~/dotfiles/` - edit there and changes apply immediately.

## Credits

Configurations inspired by various dotfile repos and customized for personal workflow.

---

**Maintainer**: mikkurogue  
**License**: MIT

## Notes

- Make sure to review and adjust paths in configuration files after installation
- Fish (set during install)
- Configured for AMD GPUs with Wayland

 Some scripts may require additional dependencies
