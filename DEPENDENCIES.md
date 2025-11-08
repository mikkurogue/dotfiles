# System Dependencies

This document lists all the dependencies required for this dotfiles setup.

## Core Hyprland Setup

### Window Manager
- `hyprland` - The Hyprland compositor
- `hypridle` - Idle management daemon
- `hyprlock` - Screen locker
- `hyprpaper` - Wallpaper manager (optional, for future use)

### Status Bar
- `waybar` - Status bar for Wayland

### Notifications
- `mako` - Notification daemon for Wayland

### Application Launcher & Menu
- `walker` - Application launcher (alternative to rofi/wofi)

## Shell & Terminal

### Shell
- `zsh` - Z shell
- `starship` - Cross-shell prompt

### Terminal Emulator
- `ghostty` - Terminal emulator

## System Utilities

### Audio Control
- `pipewire` - Audio server
- `wireplumber` - Session/policy manager for PipeWire
- `wpctl` - WirePlumber control utility (comes with wireplumber)
- `playerctl` - Media player controller

### Brightness Control
- `brightnessctl` - Brightness control utility

### Input Method
- `fcitx5` - Input method framework (if you need multiple languages)

### Authentication Agent
- `polkit-gnome` - PolicyKit authentication agent

### File Manager
- `thunar` - File manager

### Other
- `jq` - JSON processor (used in scripts)
- `gnome-calculator` - Calculator app (optional)

## Development Tools

### Editor
- `neovim` - Text editor
- Language servers (depending on your nvim config)

### Git
- `git` - Version control
- `gh` - GitHub CLI (optional)

## Monitoring & Info

### System Monitor
- `btop` - System monitor (referenced in config)

### System Info
- `fastfetch` - System information tool (referenced in config)

## Optional/Referenced Tools

### Screenshots & Color Picker
- `hyprshot` - Screenshot tool for Hyprland
- `hyprpicker` - Color picker for Hyprland

### Clipboard
- `wl-clipboard` - Clipboard utilities for Wayland (required for walker clipboard mode)

### File Listing
- `eza` - Modern ls replacement (referenced in config)

### Fonts
- `ttf-cascadia-code-nerd` or `CaskaydiaMono Nerd Font` - Used in waybar and other configs

## Installation Command (Arch Linux)

```bash
# Core system
paru -S hyprland hypridle hyprlock waybar mako walker

# Shell & terminal
paru -S zsh starship ghostty

# Audio & media
paru -S pipewire wireplumber playerctl

# System utilities
paru -S brightnessctl fcitx5 polkit-gnome thunar

# Development
paru -S neovim git gh

# Monitoring
paru -S btop fastfetch

# Optional tools
paru -S hyprshot hyprpicker wl-clipboard eza jq

# Fonts
paru -S ttf-cascadia-code-nerd
```

## Zsh Plugins (Included in dotfiles)

These are already included in the dotfiles repository:
- `zsh-syntax-highlighting` - Already in `~/dotfiles/zsh/`

Additional plugins you may want to install separately:
- `zsh-autosuggestions` - Fish-like autosuggestions (referenced in .zshrc)
- `fzf-tab` - Replace zsh's default completion with fzf (referenced in .zshrc)

## Notes

- Some tools are optional depending on your workflow
- Remove `fcitx5` if you don't need multi-language input
- The `elephant` file manager can be replaced with `thunar`, `nautilus`, or any other file manager
- Omarchy-specific commands in configs have been commented out or removed
