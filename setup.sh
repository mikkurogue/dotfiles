#!/bin/bash

set -e  # Exit on error

DOTFILES_DIR="$HOME/dotfiles"

echo "=================================="
echo "Dotfiles Setup Script"
echo "=================================="
echo ""

# Function to create backup or keep correct symlink
backup_if_exists() {
    # $1 = destination path, $2 = expected target
    if [ -L "$1" ]; then
        local current_target="$(readlink "$1")"
        if [ "$current_target" = "$2" ]; then
            echo "Symlink $1 already points to $2; skipping."
            return 0
        else
            echo "Removing existing symlink $1 (was -> $current_target)"
            rm "$1"
        fi
    elif [ -e "$1" ]; then
        echo "Backing up existing $1 to $1.backup"
        mv "$1" "$1.backup"
    fi
}

# Backup and symlink .zshrc
echo "Setting up zsh configuration..."
backup_if_exists "$HOME/.zshrc" "$DOTFILES_DIR/.zshrc"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Backup and symlink starship.toml
echo "Setting up starship configuration..."
mkdir -p "$HOME/.config"
backup_if_exists "$HOME/.config/starship.toml" "$DOTFILES_DIR/starship.toml"
ln -sf "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

# Backup and symlink git config directory
echo "Setting up git configuration..."
backup_if_exists "$HOME/.config/git" "$DOTFILES_DIR/git"
ln -sf "$DOTFILES_DIR/git" "$HOME/.config/git"

# Backup and symlink waybar
echo "Setting up waybar configuration..."
backup_if_exists "$HOME/.config/waybar" "$DOTFILES_DIR/.config/waybar"
ln -sf "$DOTFILES_DIR/.config/waybar" "$HOME/.config/waybar"

# Backup and symlink nvim
echo "Setting up neovim configuration..."
backup_if_exists "$HOME/.config/nvim" "$DOTFILES_DIR/.config/nvim"
ln -sf "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"

# Backup and symlink hypr
echo "Setting up hyprland configuration..."
backup_if_exists "$HOME/.config/hypr" "$DOTFILES_DIR/.config/hypr"
ln -sf "$DOTFILES_DIR/.config/hypr" "$HOME/.config/hypr"

# Backup and symlink ghostty
echo "Setting up ghostty configuration..."
backup_if_exists "$HOME/.config/ghostty" "$DOTFILES_DIR/.config/ghostty"
ln -sf "$DOTFILES_DIR/.config/ghostty" "$HOME/.config/ghostty"

# Backup and symlink fish
echo "Setting up fish configuration..."
backup_if_exists "$HOME/.config/fish" "$DOTFILES_DIR/.config/fish"
ln -sf "$DOTFILES_DIR/.config/fish" "$HOME/.config/fish"

# Backup and symlink mako
echo "Setting up mako configuration..."
backup_if_exists "$HOME/.config/mako" "$DOTFILES_DIR/.config/mako"
ln -sf "$DOTFILES_DIR/.config/mako" "$HOME/.config/mako"

# Backup and symlink noctalia
echo "Setting up noctalia configuration..."
backup_if_exists "$HOME/.config/noctalia" "$DOTFILES_DIR/.config/noctalia"
ln -sf "$DOTFILES_DIR/.config/noctalia" "$HOME/.config/noctalia"

# Setup zsh plugins directory
echo "Setting up zsh plugins..."
mkdir -p "$HOME/.zsh"
if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
    echo "Linking zsh-autosuggestions..."
    ln -sf /usr/share/zsh/plugins/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
fi

if [ ! -d "$HOME/.zsh/fzf-tab" ]; then
    echo "Installing fzf-tab..."
    git clone https://github.com/Aloxaf/fzf-tab "$HOME/.zsh/fzf-tab"
fi

# Link zsh-syntax-highlighting from dotfiles
if [ ! -e "$HOME/zsh-syntax-highlighting" ]; then
    echo "Linking zsh-syntax-highlighting from dotfiles..."
    ln -sf "$DOTFILES_DIR/zsh/zsh-syntax-highlighting" "$HOME/zsh-syntax-highlighting"
fi

echo ""
echo "=================================="
echo "Dotfiles setup complete!"
echo "=================================="
echo ""
echo "Your configuration files have been symlinked."
echo "Backups of existing configs are saved with .backup extension."
echo ""
echo "To apply zsh changes, run: source ~/.zshrc"
echo "To switch to fish shell, run: fish"
echo "To change default shell to fish, run: chsh -s \$(which fish)"
