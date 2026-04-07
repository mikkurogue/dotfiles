{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles.fish;
in
{
  options.dotfiles.fish = {
    enable = lib.mkEnableOption "dotfiles fish shell configuration";

    dotfilesPath = lib.mkOption {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/dotfiles";
      description = "Path to the dotfiles repository root.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Do NOT use programs.fish - that generates its own config.fish
    # and will overwrite the dotfiles configuration.
    # Instead, we symlink the entire fish config directory from the dotfiles repo.

    xdg.configFile = {
      "fish/config.fish".source = "${cfg.dotfilesPath}/.config/fish/config.fish";
      "fish/conf.d".source = "${cfg.dotfilesPath}/.config/fish/conf.d";
      "fish/functions".source = "${cfg.dotfilesPath}/.config/fish/functions";
      "fish/completions".source = "${cfg.dotfilesPath}/.config/fish/completions";
      "fish/fish_plugins".source = "${cfg.dotfilesPath}/.config/fish/fish_plugins";
    };

    # Ensure fish is available as a package
    home.packages = [ pkgs.fish ];
  };
}
