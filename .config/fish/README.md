# Fish Shell Configuration

This Fish configuration provides feature parity with the Zsh configuration.

## Features

- **Starship prompt**: Beautiful cross-shell prompt
- **Zoxide integration**: Smart directory jumping with the `cd` command
- **Visual feedback**: Shows arrow and colored path when changing directories
- **Directory navigation aliases**: `..`, `...`, `....`
- **PATH configuration**: Includes Cargo and Go bin directories
- **Custom aliases**: Same as Zsh config

## Custom `cd` Function

The `cd` function enhances navigation with:
- Falls back to home directory with no arguments
- Uses regular `cd` for existing directories
- Uses `zoxide` for smart directory jumping
- Shows visual feedback with arrow (󰧩) and cyan-colored path
- Error handling with colored messages

## Installation

Fish is installed via the main `install.sh` script and configured via `setup.sh`.

## Switching Shells

To try Fish:
```bash
fish
```

To set Fish as default shell:
```bash
chsh -s $(which fish)
```

To switch back to Zsh:
```bash
chsh -s $(which zsh)
```

## Fish-specific Plugins

Fish has built-in features that replace some Zsh plugins:
- **Syntax highlighting**: Built into Fish
- **Autosuggestions**: Built into Fish
- **Tab completion**: Built into Fish

No additional plugins needed!
