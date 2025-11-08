require("oil").setup({
  default_file_explorer = true,
  keymaps = {
    ["q"] = "actions.close",
    ["esc"] = "actions.close",
    ["<leader>e"] = "actions.close",
    ["<BS>"] = "actions.parent",
    ["<leader><BS>"] = "actions.parent",
    ["h"] = "actions.parent",
    ["l"] = "actions.select",
    ["<CR>"] = "actions.select",
    ["<leader>r"] = "actions.refresh",
    ["gr"] = "actions.refresh",
    ["<leader>."] = "actions.toggle_hidden",
  },
  view_options = {
    show_hidden = true,
    highlight_opened_files = "name"
  },
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 1000,
  },
  columns = {
    "icon",
  },
  float = {
    padding = 2,
    border = "rounded",
    max_width = 0.5,
    max_height = 0.5,
  },
  open = "float",
})
