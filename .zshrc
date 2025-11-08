
eval "$(starship init zsh)"

# Enable Zsh completion system
autoload -Uz compinit
compinit

eval "$(zoxide init zsh)"
# alias cd="z"
alias rev="/home/mikku/.cargo/bin/rev"

alias git-purge="git fetch -p && git branch --merged | grep -v '*' | grep -v 'master' | xargs git branch -d"

if command -v zoxide &>/dev/null; then
  zd() {
    local old=$PWD

    if [[ $# -eq 0 ]]; then
      builtin cd ~ || return
    elif [[ -d "$1" ]]; then
      builtin cd "$1" || return
    else
      z "$@" || { print -P "%F{red}Error:%f Directory not found"; return 1; }
    fi

    local new=$PWD
    if [[ "$old" != "$new" ]]; then
      # show arrow and current path
      printf "\U000F17A9 "
      print -P "%F{cyan}${new/#$HOME/~}%f"
    fi
  }

  alias cd="zd"
fi

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

export PATH=$PATH:/usr/local/go/bin
# . "$HOME/.cargo/env"
export PATH="$HOME/.cargo/bin:$PATH"

#alias ls="fview -u=m -r"
source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
