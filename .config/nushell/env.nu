# env.nu - Environment configuration for Nushell
# Migrated from fish config

# ── PATH Configuration ────────────────────────────────────────────
use std/util "path add"

# Rust / Cargo
path add "/usr/local/bin"
path add ($env.HOME | path join ".cargo" "bin")

# Go
path add "/usr/local/go/bin"
path add ($env.HOME | path join "go" "bin")

# Python / UV local bin
path add ($env.HOME | path join ".local" "bin")

# Nix
if ($env.HOME | path join ".nix-profile" "bin" | path exists) {
    path add ($env.HOME | path join ".nix-profile" "bin")
}
if ("/nix/var/nix/profiles/default/bin" | path exists) {
    path add "/nix/var/nix/profiles/default/bin"
}

# Vite+ bin
if ($env.HOME | path join ".vite-plus" "bin" | path exists) {
    path add ($env.HOME | path join ".vite-plus" "bin")
}

# Opam (OCaml)
if ($env.HOME | path join ".opam" "default" "bin" | path exists) {
    path add ($env.HOME | path join ".opam" "default" "bin")
}

# ── Environment Variables ─────────────────────────────────────────
$env.NX_TUI = "false"

# ── Starship Prompt ───────────────────────────────────────────────
$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)' --terminal-width (term size).columns
}

def create_right_prompt [] {
    starship prompt --right --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)' --terminal-width (term size).columns
}

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = "::: "
