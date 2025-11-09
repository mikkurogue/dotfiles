set fish_greeting
# Starship prompt
starship init fish | source

# Zoxide initialization
zoxide init fish | source

# Aliases
alias rev="/home/mikku/.cargo/bin/rev"
alias git-purge="git fetch -p && git branch --merged | grep -v '*' | grep -v 'master' | xargs git branch -d"

# Directory navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# PATH configuration
set -gx PATH $PATH /usr/local/go/bin
set -gx PATH $HOME/.cargo/bin $PATH

alias ls="eza -l --no-permissions --icons --color=always --sort=created --group-directories-first"
