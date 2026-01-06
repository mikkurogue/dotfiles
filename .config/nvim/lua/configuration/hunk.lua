require("hunk").setup({
  ui = {
    tree = {
      mode = "nested",
      width = 35,
    },
    layout = "vertical",
  },
  icons = {
    selected = "󰡖",
    deselected = "",
    partially_selected = "󰛲",
    folder_open = "",
    folder_closed = "",
  },
  keys = {
    global = {
      quit = { "q" },
      accept = { "<leader><cr>" },
      focus_tree = { "<leader>e" },
    },
    tree = {
      expand_node = { "l", "<Right>" },
      collapse_node = { "h", "<Left>" },
      open_file = { "<cr>" },
      toggle_file = { "a" },
    },
    diff = {
      toggle_line = { "a" },
      toggle_hunk = { "A" },
      toggle_line_pair = { "s" },
      prev_hunk = { "[c" },
      next_hunk = { "]c" },
      toggle_focus = { "<Tab>" },
    },
  },
})

vim.api.nvim_create_user_command("DiffEditor", function()
  require("hunk").open()
end, {})
