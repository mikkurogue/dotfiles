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
    hyprland \
    hypridle \
    hyprlock \
    hyprpaper \
    niri \
    walker \
    wofi \
    noctalia-shell \
    wlsunset \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk

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
    zsh-autosuggestions \
    zsh-syntax-highlighting

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
    xembedsniproxy

# === Audio & Media ===
echo ""
echo "========================================"
echo "Installing Audio & Media"
echo "========================================"
yay -S --needed --noconfirm \
    pipewire \
    pipewire-pulse \
    pipewire-alsa \
    pipewire-jack \
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
    dunst \
    dolphin \
    thunar \
    jq \
    zoxide \
    fzf \
    ripgrep \
    fd \
    bat \
    qt5ct \
    qt6ct \
    kvantum \
    breeze-icons \
    adw-gtk3 \
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
    nodejs \
    npm \
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
    xclip

# === Fonts ===
echo ""
echo "========================================"
echo "Installing Fonts"
echo "========================================"
yay -S --needed --noconfirm \
    ttf-cascadia-code-nerd \
    ttf-cascadia-mono-nerd \
    ttf-zed-mono-nerd \
    noto-fonts \
    noto-fonts-emoji \

# === Gaming (Wine & Steam) ===
echo ""
echo "========================================"
echo "Installing Gaming Components"
echo "========================================"
yay -S --needed --noconfirm \
    wine-staging \
    mesa \
    lib32-mesa \
    vulkan-icd-loader \
    lib32-vulkan-icd-loader \
    xf86-video-amdgpu \
    giflib \
    lib32-giflib \
    gnutls \
    lib32-gnutls \
    v4l-utils \
    lib32-v4l-utils \
    libpulse \
    lib32-libpulse \
    alsa-plugins \
    lib32-alsa-plugins \
    alsa-lib \
    lib32-alsa-lib \
    sqlite \
    lib32-sqlite \
    libxcomposite \
    lib32-libxcomposite \
    ocl-icd \
    lib32-ocl-icd \
    libva \
    lib32-libva \
    gtk3 \
    lib32-gtk3 \
    gst-plugins-base-libs \
    lib32-gst-plugins-base-libs \
    sdl2 \
    lib32-sdl2 \
    libva-mesa-driver \
    lib32-libva-mesa-driver \
    mesa-vdpau \
    lib32-mesa-vdpau \
    libva-vdpau-driver \
    lib32-libva-vdpau-driver \
    vulkan-radeon \
    lib32-vulkan-radeon \
    fuse2 \
    steam \
    faugus-launcher-git

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

# === Rust & Cargo ===
if ! command -v cargo &> /dev/null; then
    echo ""
    echo "========================================"
    echo "Installing Rust & Cargo"
    echo "========================================"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "✓ Rust and Cargo already installed"
fi

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
