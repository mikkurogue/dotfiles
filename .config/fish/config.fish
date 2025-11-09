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


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/home/mikku/.opam/opam-init/init.fish' && source '/home/mikku/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration
