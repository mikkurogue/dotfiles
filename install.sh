#!/bin/bash

set -e  # Exit on error

echo "=================================="
echo "CachyOS Dotfiles Installation"
echo "=================================="
echo ""
echo "This will install all dependencies"
echo "for a complete Hyprland/Niri setup"
echo ""

# Update system packages
echo "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install yay if not already installed
if ! command -v yay &> /dev/null; then
    echo ""
    echo "Installing yay AUR helper..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
else
    echo "✓ yay is already installed"
fi

# === Core Window Managers & Compositors ===
echo ""
echo "========================================"
echo "Installing Window Managers & Wayland"
echo "========================================"
yay -S --needed --noconfirm \
    awww \
    niri \
    vicinae \
    wlsunset \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk
    # hyprland \
    # hypridle \
    # hyprlock \
    # hyprpaper \


# === Shell & Terminal ===
echo ""
echo "========================================"
echo "Installing Shell & Terminal"
echo "========================================"
yay -S --needed --noconfirm \
    zsh \
    fish \
    starship \
    ghostty-git \
    kitty \
    zsh-autosuggestions \
    zsh-syntax-highlighting \

# === Wayland Utilities ===
echo ""
echo "========================================"
echo "Installing Wayland Utilities"
echo "========================================"
yay -S --needed --noconfirm \
    waybar \
    wl-clipboard \
    wl-clip-persist \
    grim \
    slurp \

# === Audio & Media ===
echo ""
echo "========================================"
echo "Installing Audio & Media"
echo "========================================"
yay -S --needed --noconfirm \
    pipewire \
    pipewire-pulse \
    wireplumber \
    playerctl \
    swayosd \
    pavucontrol \
    pwvucontrol

# === System Utilities ===
echo ""
echo "========================================"
echo "Installing System Utilities"
echo "========================================"
yay -S --needed --noconfirm \
    brightnessctl \
    polkit-gnome \
    swaync \
    dolphin \
    thunar \
    jq \
    zoxide \
    fzf \
    ripgrep \
    fd \
    qt5ct \
    qt6ct \
    kvantum \
    breeze-icons \
    adw-gtk3 \
    ntfs-3g \
    adw-gtk-theme

# === Development Tools ===
echo ""
echo "========================================"
echo "Installing Development Tools"
echo "========================================"
yay -S --needed --noconfirm \
    neovim-nightly-bin \
    git \
    github-cli \
    jujutsu \
    lazygit \
    tmux

# === Monitoring & Info ===
echo ""
echo "========================================"
echo "Installing Monitoring Tools"
echo "========================================"
yay -S --needed --noconfirm \
    btop \
    fastfetch

# === File & Directory Tools ===
echo ""
echo "========================================"
echo "Installing File Tools"
echo "========================================"
yay -S --needed --noconfirm \
    eza \
    xclip \
    bat \
    tree

# === Fonts ===
echo ""
echo "========================================"
echo "Installing Fonts"
echo "========================================"
yay -S --needed --noconfirm \
    ttf-cascadia-code-nerd \
    ttf-zed-mono-nerd \
    noto-fonts-emoji \

# === Gaming (Wine & Steam) ===
echo ""
echo "========================================"
echo "Installing Gaming Components"
echo "========================================"
yay -S --needed --noconfirm \
    wine-staging \
     fuse2 \
    steam \
    faugus-launcher-git
#     mesa \
#     lib32-mesa \
#     vulkan-icd-loader \
#     lib32-vulkan-icd-loader \
#     xf86-video-amdgpu \
#     giflib \
#     lib32-giflib \
#     gnutls \
#     lib32-gnutls \
#     v4l-utils \
#     lib32-v4l-utils \
#     libpulse \
#     lib32-libpulse \
#     alsa-plugins \
#     lib32-alsa-plugins \
#     alsa-lib \
#     lib32-alsa-lib \
#     sqlite \
#     lib32-sqlite \
#     libxcomposite \
#     lib32-libxcomposite \
#     ocl-icd \
#     lib32-ocl-icd \
#     libva \
#     lib32-libva \
#     gtk3 \
#     lib32-gtk3 \
#     gst-plugins-base-libs \
#     lib32-gst-plugins-base-libs \
#     sdl2 \
#     lib32-sdl2 \
#     libva-mesa-driver \
#     lib32-libva-mesa-driver \
#     mesa-vdpau \
#     lib32-mesa-vdpau \
#     libva-vdpau-driver \
#     lib32-libva-vdpau-driver \
#     vulkan-radeon \
#     lib32-vulkan-radeon \


# === Desktop Applications ===
echo ""
echo "========================================"
echo "Installing Desktop Applications"
echo "========================================"
yay -S --needed --noconfirm \
    discord \
    firefox

# === AMD GPU Utilities ===
echo ""
echo "========================================"
echo "Installing AMD GPU Utilities"
echo "========================================"
yay -S --needed --noconfirm \
    radeon-profile-git

# # === Rust & Cargo ===
# if ! command -v cargo &> /dev/null; then
#     echo ""
#     echo "========================================"
#     echo "Installing Rust & Cargo"
#     echo "========================================"
#     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s
#     source "$HOME/.cargo/env"
# else
#     echo "✓ Rust and Cargo already installed"
# fi

# === Additional Development Tools ===
echo ""
echo "========================================"
echo "Installing Additional Dev Tools"
echo "========================================"
yay -S --needed --noconfirm \
    zig \
    go

# === Cargo Packages ===
echo ""
echo "========================================"
echo "Installing Cargo Packages"
echo "========================================"
source "$HOME/.cargo/env" 2>/dev/null || true
cargo install jj-starship

# === Kunai (input device configuration) ===
echo ""
echo "========================================"
echo "Installing Kunai"
echo "========================================"
echo "Kunai is not available on the AUR or nixpkgs."
echo "Cloning from github.com/mikkurogue/kunai.git..."
if [ ! -d "$HOME/kunai" ]; then
    git clone https://github.com/mikkurogue/kunai.git "$HOME/kunai"
    cd "$HOME/kunai"
    cargo install --path .
    cd -
    echo "✓ Kunai installed"
else
    echo "✓ Kunai directory already exists at ~/kunai"
    echo "  To rebuild: cd ~/kunai && cargo install --path ."
fi

# === Setup udev rules for Vial keyboard ===
echo ""
echo "========================================"
echo "Setting up Vial WebHID rules"
echo "========================================"
if [ -f "$HOME/50-vial-webhid.rules" ]; then
    sudo cp "$HOME/50-vial-webhid.rules" /etc/udev/rules.d/50-vial-webhid.rules
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    echo "✓ Vial udev rules installed"
else
    echo "⚠ 50-vial-webhid.rules not found in home directory"
fi

# === Setup environment.d ===
echo ""
echo "========================================"
echo "Setting up environment.d"
echo "========================================"
mkdir -p "$HOME/.config/environment.d"
if [ -d "$HOME/.config/environment.d" ]; then
    # Create QT config
    cat > "$HOME/.config/environment.d/qt.conf" << 'EOF'
QT_QPA_PLATFORMTHEME=qt6ct
EOF
    # Create Wine config
    cat > "$HOME/.config/environment.d/wine.conf" << 'EOF'
WINE_FULLSCREEN_INTEGER_SCALING=1
EOF
    echo "✓ environment.d configs created"
fi

# === Setup fstab for drive mounting ===
echo ""
echo "========================================"
echo "Setting up drive mounting in fstab"
echo "========================================"

# Create mount points if they don't exist
sudo mkdir -p /mnt/samsung870
sudo mkdir -p /mnt/sda2

# Backup fstab
sudo cp /etc/fstab /etc/fstab.backup

# Add entries if they don't already exist
if ! grep -q "C0944D45944D3EE2" /etc/fstab; then
    echo "UUID=C0944D45944D3EE2 /mnt/samsung870 ntfs-3g defaults,uid=1000,gid=1000,umask=022 0 0" | sudo tee -a /etc/fstab
    echo "✓ Added Samsung 870 NTFS drive to fstab"
else
    echo "✓ Samsung 870 NTFS drive already in fstab"
fi

if ! grep -q "45ed6a1e-9e77-4f89-a618-6e806397f94a" /etc/fstab; then
    echo "UUID=45ed6a1e-9e77-4f89-a618-6e806397f94a /mnt/sda2 btrfs defaults 0 0" | sudo tee -a /etc/fstab
    echo "✓ Added sda2 btrfs drive to fstab"
else
    echo "✓ sda2 btrfs drive already in fstab"
fi

echo "✓ fstab configured for automatic drive mounting"

# === Change default shell ===
if [ "$SHELL" != "$(which fish)" ]; then
    echo ""
    echo "========================================"
    echo "Changing default shell to fish"
    echo "========================================"
    chsh -s $(which fish)
    echo "✓ Default shell changed to fish"
else
    echo "✓ Default shell is already fish"
fi

echo ""
echo "========================================"
echo "Installation Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Log out and log back in for shell changes to take effect"
echo "2. Run './setup.sh' to symlink all dotfiles"
echo "3. Reboot to ensure all services start correctly"
echo ""
echo "Optional:"
echo "- Install Nix: curl --proto '=https' --tlsv1.2 -sSfL https://nixos.org/nix/install -o nix-install.sh && chmod +x ./nix-install.sh && ./nix-install.sh --daemon"
echo "- See flake.nix for future home-manager setup"
echo ""
