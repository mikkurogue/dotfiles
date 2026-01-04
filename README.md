# Mikku's Dotfiles

Personal configuration files for CachyOS/Arch Linux with Hyprland and Niri window managers.

## 🚀 Quick Start (Fresh CachyOS Install)

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
- **Walker** - Application launcher
- **Wofi** - Application launcher
- **Noctalia Shell** - Custom shell components

### Shell & Terminal
- **Fish** - Default shell
- **Zsh** - Alternative shell with plugins
- **Starship** - Cross-shell prompt
- **Ghostty** - Terminal emulator

### Development Tools
- **Neovim Nightly** - Text editor
- **Jujutsu (jj)** - Version control
- **Git** - Version control
- **GitHub CLI** - GitHub integration
- **Lazygit** - Git TUI
- **Node.js & npm** - JavaScript runtime
- **Rust & Cargo** - Rust toolchain
- **Zig** - Zig compiler
- **Go** - Go compiler

### Utilities
- **Waybar** - Status bar
- **Dunst** - Notifications
- **SwayOSD** - On-screen display
- **Grim + Slurp** - Screenshots
- **Brightnessctl** - Brightness control
- **Playerctl** - Media control
- **Fcitx5** - Input method
- **Zoxide** - Smart cd
- **Eza** - Better ls
- **Bat** - Better cat
- **Fzf** - Fuzzy finder
- **Ripgrep** - Fast grep
- **Btop** - System monitor
- **Fastfetch** - System info

### Desktop Apps
- **Firefox** - Web browser
- **Discord** - Chat
- **Dolphin** - File manager
- **Steam** - Gaming
- **Faugus Launcher** - Game launcher

### Gaming Support
- **Wine Staging** - Windows compatibility
- **AMD GPU drivers** - Full Vulkan/Mesa support
- **32-bit libraries** - For gaming compatibility

## 📁 Directory Structure

```
~/dotfiles/
├── .config/
│   ├── hypr/          # Hyprland configuration
│   ├── niri/          # Niri configuration
│   ├── waybar/        # Status bar
│   ├── nvim/          # Neovim config
│   ├── fish/          # Fish shell
│   ├── ghostty/       # Terminal
│   ├── noctalia/      # Shell components
│   ├── jj/            # Jujutsu config
│   └── fastfetch/     # System info
├── git/               # Git configuration
├── zsh/               # Zsh plugins
├── starship.toml      # Prompt config
├── .zshrc             # Zsh config
├── install.sh         # Dependency installer
├── setup.sh           # Dotfiles symlinker
├── flake.nix          # Nix flake (optional)
├── home.nix           # Home Manager config (optional)
└── 50-vial-webhid.rules  # Keyboard udev rules
```

## 🔧 Configuration Files

### Hyprland
Modular configuration split across:
- `hyprland.conf` - Main config
- `monitors.conf` - Display setup
- `input.conf` - Keyboard/mouse
- `bindings.conf` - Keybindings
- `looknfeel.conf` - Theming
- `autostart.conf` - Startup apps
- `envs.conf` - Environment variables

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

## 🔄 Optional: Nix Home Manager

For a declarative, reproducible setup across machines, see [README-NIX.md](./README-NIX.md).

```bash
# Install Nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# Switch to Home Manager
home-manager switch --flake .#mikku
```

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

## 📝 Notes

- **Default shell**: Fish (set during install)
- **Terminal**: Ghostty with Cascadia Code Nerd Font
- **Theme**: Custom Osmium colors with Rose Pine accents
- **Input method**: Fcitx5 for multi-language support
- **Display**: Configured for AMD GPUs with Wayland

## 🤝 Credits

Configurations inspired by various dotfile repos and customized for personal workflow.

---

**Maintainer**: mikkurogue  
**License**: MIT

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
