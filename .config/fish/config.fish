set fish_greeting
# PATH configuration
set -gx PATH $PATH /usr/local/go/bin
set -gx PATH $HOME/.cargo/bin $PATH

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
alias rmv='rmv -l "spinner"'

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
