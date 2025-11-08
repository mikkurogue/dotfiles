#!/bin/bash

set -e  # Exit on error

echo "=================================="
echo "Dotfiles Installation Script"
echo "=================================="
echo ""

# Update system packages
echo "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install yay if not already installed
if ! command -v yay &> /dev/null; then
    echo "Installing yay AUR helper..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
else
    echo "yay is already installed, skipping..."
fi

# Core Hyprland Setup
echo ""
echo "Installing core Hyprland components..."
yay -S --needed --noconfirm hyprland hypridle hyprlock hyprpaper waybar mako walker

# Shell & Terminal
echo ""
echo "Installing shell and terminal..."
yay -S --needed --noconfirm zsh starship ghostty-git
yay -S --needed --noconfirm zsh-autosuggestions zsh-syntax-highlighting

# Audio & Media
echo ""
echo "Installing audio and media tools..."
yay -S --needed --noconfirm pipewire wireplumber playerctl

# System Utilities
echo ""
echo "Installing system utilities..."
yay -S --needed --noconfirm brightnessctl fcitx5 polkit-gnome thunar jq elephant zoxide

# Development Tools
echo ""
echo "Installing development tools..."
yay -S --needed --noconfirm neovim-nightly-bin git github-cli nodejs npm rustup 

# Monitoring & Info
echo ""
echo "Installing monitoring tools..."
yay -S --needed --noconfirm btop fastfetch

# Screenshots & Color Picker
echo ""
echo "Installing screenshot tools..."
yay -S --needed --noconfirm hyprshot hyprpicker grim slurp

# Other utilities
echo ""
echo "Installing other utilities..."
yay -S --needed --noconfirm wl-clipboard eza xclip tmux lazygit

# Fonts
echo ""
echo "Installing fonts..."
yay -S --needed --noconfirm ttf-cascadia-code-nerd

# Gaming (Wine & Faugus Launcher)
echo ""
echo "Installing gaming components..."
yay -S --needed --noconfirm wine-staging mesa lib32-mesa vulkan-icd-loader lib32-vulkan-icd-loader \
    xf86-video-amdgpu giflib lib32-giflib gnutls lib32-gnutls \
    v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins \
    alsa-lib lib32-alsa-lib sqlite lib32-sqlite libxcomposite lib32-libxcomposite \
    ocl-icd lib32-ocl-icd libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs \
    lib32-gst-plugins-base-libs sdl2 lib32-sdl2 \
    libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau \
    libva-vdpau-driver lib32-libva-vdpau-driver vulkan-radeon lib32-vulkan-radeon \
    fuse2

echo ""
echo "Installing Steam..."
yay -S --needed --noconfirm steam

echo ""
echo "Installing Faugus Launcher..."
yay -S --needed --noconfirm faugus-launcher-git

# Other apps
echo ""
echo "Installing other applications..."
yay -S --needed --noconfirm discord

# AMD GPU tools
echo ""
echo "Installing AMD GPU utilities..."
yay -S --needed --noconfirm radeon-profile-git

# Rust & Cargo
if ! command -v cargo &> /dev/null; then
    echo ""
    echo "Installing Rust and Cargo..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "Rust and Cargo already installed, skipping..."
fi

# Zig
echo ""
echo "Installing Zig..."
yay -S --needed --noconfirm zig

# Change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo ""
    echo "Changing default shell to zsh..."
    chsh -s $(which zsh)
else
    echo "Default shell is already zsh, skipping..."
fi

echo ""
echo "=================================="
echo "Installation complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "1. Log out and log back in for shell changes to take effect"
echo "2. Run the dotfiles setup to symlink configs"
echo "3. Enjoy your new system!"
