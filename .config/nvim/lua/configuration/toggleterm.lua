return {
  "akinsho/toggleterm.nvim",
  cmd = "ToggleTerm",
  keys = {
    { "<leader>tf", ":ToggleTerm<CR>", desc = "Toggle terminal" },
  },
  opts = {
    direction = "float",
    float_opts = {
      border = "rounded",
    },
    winbar = {
      enabled = true,
      name_formatter = function(term)
        return term.name
      end,
    },
  },
}
