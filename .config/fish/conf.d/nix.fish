# Nix profile initialization
if test -e "$HOME/.nix-profile/etc/profile.d/nix.fish"
    . "$HOME/.nix-profile/etc/profile.d/nix.fish"
else if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.fish
    . /nix/var/nix/profiles/default/etc/profile.d/nix.fish
end
