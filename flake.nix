{
  description = "Mikku's Dotfiles - NixOS & Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland (if you want the latest)
    # hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # Home Manager configuration
      # Usage: home-manager switch --flake .#mikku
      homeConfigurations."mikku" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        
        modules = [
          ./home.nix
        ];

        # Pass flake inputs to modules
        extraSpecialArgs = { inherit inputs; };
      };

      # For full NixOS systems (future use)
      # nixosConfigurations."hostname" = nixpkgs.lib.nixosSystem {
      #   inherit system;
      #   modules = [
      #     ./configuration.nix
      #     home-manager.nixosModules.home-manager
      #   ];
      # };
    };
}
