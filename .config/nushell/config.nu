# config.nu - Main Nushell configuration
# Migrated from fish config

# ── General Settings ──────────────────────────────────────────────
$env.config.show_banner = false

$env.config.history = {
    file_format: sqlite
    max_size: 100_000
    sync_on_enter: true
    isolation: false
}

$env.config.completions = {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: prefix
}

$env.config.table = {
    mode: rounded
    index_mode: always
    show_empty: true
    padding: { left: 1, right: 1 }
    trim: {
        methodology: wrapping
        wrapping_try_keep_words: true
    }
}

$env.config.cursor_shape = {
    emacs: line
    vi_insert: line
    vi_normal: block
}

$env.config.buffer_editor = "nvim"

# ── Aliases (external commands use ^) ─────────────────────────────

# Directory navigation
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..

# Common aliases
alias cat = ^bat --paging=never
alias ff = ^fd
alias c = clear
alias x = exit
alias vim = ^nvim
alias fucking = sudo
alias grep = ^rg --color=always

# ── Zoxide ────────────────────────────────────────────────────────
# Regenerate with: zoxide init nushell | save -f ~/.cache/zoxide/init.nu
source ~/.cache/zoxide/init.nu

# ── Custom Commands ───────────────────────────────────────────────

# cd with zoxide integration and visual feedback (like fish version)
def --env cdd [...args: string] {
    let old = $env.PWD
    if ($args | is-empty) {
        cd ~
    } else if ($args.0 | path exists) and ($args.0 | path type) == "dir" {
        cd $args.0
    } else {
        z ...$args
    }
    let new = $env.PWD
    if $old != $new {
        let display = ($new | str replace $env.HOME "~")
        print $"(ansi cyan)($display)(ansi reset)"
    }
}

# History search with fzf
def fzf-history [] {
    history | get command | reverse | uniq | str join (char newline) | ^fzf --tac | str trim
}

# Open file with fzf + nvim
def fzf-file [] {
    let file = (^fd --type f | ^fzf | str trim)
    if ($file | is-not-empty) {
        ^nvim $file
    }
}

# cd to directory with fzf
def --env fzf-dir [] {
    let dir = (^fd --type d | ^fzf | str trim)
    if ($dir | is-not-empty) {
        cd $dir
    }
}

# Quick history search
def h [] {
    history | get command | reverse | uniq | str join (char newline) | ^fzf
}

# ── Keybindings ───────────────────────────────────────────────────
$env.config.keybindings = ($env.config.keybindings | append [
    {
        name: fuzzy_history
        modifier: control
        keycode: char_r
        mode: [emacs vi_insert vi_normal]
        event: {
            send: executehostcommand
            cmd: "commandline edit --replace (fzf-history)"
        }
    }
    {
        name: fuzzy_file
        modifier: control
        keycode: char_t
        mode: [emacs vi_insert vi_normal]
        event: {
            send: executehostcommand
            cmd: "fzf-file"
        }
    }
])
