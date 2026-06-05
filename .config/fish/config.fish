set fish_greeting
# Nix
if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end
fish_add_path --prepend /nix/var/nix/profiles/default/bin
fish_add_path --prepend $HOME/.nix-profile/bin

# PATH configuration
set -gx PATH $HOME/.cargo/bin $PATH
set -gx PATH $PATH /usr/local/go/bin

# macOS-specific paths
if test (uname) = Darwin
    # Docker Desktop
    test -d /Applications/Docker.app/Contents/Resources/bin
    and fish_add_path /Applications/Docker.app/Contents/Resources/bin

    # Zerobrew
    test -d /opt/zerobrew/bin
    and fish_add_path /opt/zerobrew/bin
    test -d /opt/zerobrew/prefix/bin
    and fish_add_path /opt/zerobrew/prefix/bin
    test -d $HOME/.zerobrew/bin
    and fish_add_path $HOME/.zerobrew/bin
    
    # homebrew (disgusting)
    test -d /opt/homebrew/bin/brew
    and eval "$(/opt/homebrew/bin/brew shellenv fish)"


    # activate mise
    /opt/zerobrew/bin/mise activate fish | source


    source /Users/michaellindemans/.safe-chain/scripts/init-fish.fish # Safe-chain Fish initialization script
end

set -gx  NX_TUI false

# export NX_TUI=false
# set -gx VITE_PLUS_NODE_VERSION 25.8.1
# Starship prompt
starship init fish | source

# Zoxide initialization
zoxide init fish | source

# Directory navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ls="eza -l --no-permissions --icons --color=always --sort=created --group-directories-first"
alias cat="bat --paging=never"
alias ff="fd"
# alias sudo="sudo-rs"
alias c="clear"
alias x="exit"
alias vim="nvim"
alias fucking='sudo'
alias fuck='sudo (history | tail -n1)'
alias grep='rg --color=always'
alias rmv='rmv'

function h
  history | fzf
end

function fzf_history
    history | fzf --tac | read -l command
    commandline $command
end

bind \cr fzf_history

function fzf_file
    fd --type f | fzf | read -l file
    and nvim $file
end

bind \ct fzf_file

function fzf_dir
    fd --type d | fzf | read -l dir
    and cd $dir
end

bind \ec fzf_dir


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r "$HOME/.opam/opam-init/init.fish" && source "$HOME/.opam/opam-init/init.fish" > /dev/null 2> /dev/null; or true
# END opam configuration

# Vite+ bin (https://viteplus.dev)
source "$HOME/.vite-plus/env.fish"


# Added by Radicle.
export PATH="$PATH:/home/mikku/.radicle/bin"

# Pi
fish_add_path "/home/mikku/.vite-plus/js_runtime/node/26.0.0/bin"

