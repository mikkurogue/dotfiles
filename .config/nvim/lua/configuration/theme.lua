-- Gruvbox, hard contrast (darkest background).
-- NB: this port uses `contrast = "hard"`, not `flavour = "hard"` (that's other ports).
-- Must be loaded before `:colorscheme gruvbox`, hence priority + config = true.
return {
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 1000,
  config = true,
  opts = {
    contrast = "hard",
    terminal_colors = true,
    undercurl = true,
    underline = true,
    italic = {
      strings = true,
      emphasis = true,
      comments = true,
      folds = true,
    },
    inverse = true,
    transparent_mode = false,
  },
}
