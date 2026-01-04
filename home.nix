{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "mikku";
  home.homeDirectory = "/home/mikku";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # ========================================
  # Packages
  # ========================================
  home.packages = with pkgs; [
    # Shell & CLI tools
    zoxide
    eza
    bat
    fzf
    ripgrep
    fd
    jq
    btop
    fastfetch
    
    # Development
    lazygit
    gh
    
    # Rust tools (managed by rustup typically)
    # nodejs
    # cargo
    
    # Add more packages as needed
  ];

  # ========================================
  # Programs - Declarative Configuration
  # ========================================
  
  programs.git = {
    enable = true;
    userName = "mikkurogue";
    userEmail = "michael.lindemans@outlook.com";
    
    extraConfig = {
      # Add your git config here
    };
  };

  programs.starship = {
    enable = true;
    # Starship config will be symlinked from dotfiles
    # Or you can manage it declaratively here
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    initExtra = ''
      eval "$(zoxide init zsh)"
      
      # Custom aliases
      alias rev="$HOME/.cargo/bin/rev"
      alias git-purge="git fetch -p && git branch --merged | grep -v '*' | grep -v 'master' | xargs git branch -d"
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'
      alias ls="eza -l --no-permissions --icons --color=always --sort=created --group-directories-first"
      alias cat="bat"
    '';
  };

  programs.fish = {
    enable = true;
    
    shellInit = ''
      set fish_greeting
    '';
    
    interactiveShellInit = ''
      starship init fish | source
      zoxide init fish | source
    '';
    
    shellAliases = {
      rev = "$HOME/.cargo/bin/rev";
      git-purge = "git fetch -p && git branch --merged | grep -v '*' | grep -v 'master' | xargs git branch -d";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      ls = "eza -l --no-permissions --icons --color=always --sort=created --group-directories-first";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.tmux = {
    enable = true;
  };

  # ========================================
  # File Management - Symlink dotfiles
  # ========================================
  
  # Option 1: Use home.file for symlinking
  # home.file.".config/hypr".source = ./config/hypr;
  # home.file.".config/waybar".source = ./config/waybar;
  
  # Option 2: Use xdg.configFile (preferred for XDG-compliant configs)
  xdg.configFile = {
    "hypr".source = ./.config/hypr;
    "waybar".source = ./.config/waybar;
    "nvim".source = ./.config/nvim;
    "fish".source = ./.config/fish;
    "ghostty".source = ./.config/ghostty;
    "niri".source = ./.config/niri;
    "noctalia".source = ./.config/noctalia;
    "jj".source = ./.config/jj;
    "fastfetch".source = ./.config/fastfetch;
    "starship.toml".source = ./starship.toml;
    "git".source = ./git;
  };

  # ========================================
  # Environment Variables
  # ========================================
  
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # ========================================
  # XDG User Directories
  # ========================================
  
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
