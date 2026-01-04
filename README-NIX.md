# Nix/Home-Manager Setup (Optional)

This is an **optional** setup for managing your dotfiles with Nix Home Manager.

## Prerequisites

Install Nix package manager:
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

## Quick Start with Home Manager

1. **Enable Flakes** (if not already enabled):
```bash
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << EOF
experimental-features = nix-command flakes
EOF
```

2. **Install Home Manager**:
```bash
nix run home-manager/master -- init --switch
```

3. **Use this flake**:
```bash
cd ~/dotfiles
home-manager switch --flake .#mikku
```

## What does this setup do?

- **`flake.nix`**: Entry point that defines inputs (nixpkgs, home-manager) and outputs
- **`home.nix`**: Your user configuration (packages, programs, dotfiles symlinking)

## Customization

### Add packages
Edit `home.nix` and add to `home.packages`:
```nix
home.packages = with pkgs; [
  your-package-here
];
```

### Configure programs declaratively
Many programs have native home-manager modules:
```nix
programs.git = {
  enable = true;
  userName = "your-name";
  userEmail = "your-email";
};
```

### Symlink additional dotfiles
Add to `xdg.configFile`:
```nix
xdg.configFile."your-app".source = ./.config/your-app;
```

## Why use Home Manager?

✅ **Reproducible**: Same environment on any machine  
✅ **Declarative**: Configuration as code  
✅ **Rollbacks**: Revert to previous generations  
✅ **Cross-distro**: Works on CachyOS, Ubuntu, macOS, etc.

## Current Setup (Hybrid)

Right now, you're using:
- **CachyOS/Arch**: System packages via `install.sh` + pacman/yay
- **Nix**: Optional overlay for reproducible user environment

This gives you the best of both worlds:
- Fast native packages from Arch repos
- Declarative user environment with Nix (when you want it)

## Migration Path

1. **Now**: Use `install.sh` for CachyOS setup
2. **Later**: Gradually move packages to `home.nix`
3. **Future**: Consider full NixOS for maximum reproducibility

## Useful Commands

```bash
# Switch to new configuration
home-manager switch --flake .#mikku

# List generations
home-manager generations

# Rollback
home-manager switch --rollback

# Update packages
nix flake update
home-manager switch --flake .#mikku

# Garbage collect old generations
nix-collect-garbage -d
```
