local wk = require("which-key")

wk.setup({
  preset = "helix", -- helix-style preset (the one you mentioned!)
  delay = 200,
  icons = {
    breadcrumb = ">>",
    separator = "->",
    group = "+",
    mappings = true,
    rules = {},
    colors = true,
  },
  win = {
    border = "rounded",
    padding = { 1, 2 },
    title = true,
    title_pos = "center",
  },
  layout = {
    width = { min = 20 },
    spacing = 3,
  },
  show_help = true,
  show_keys = true,
  triggers = {
    { "<auto>", mode = "nxso" },
    { "<leader>", mode = { "n", "v" } },
  },
})

-- Register key groups for the popup menu
wk.add({
  -- Top-level groups
  { "<leader>b", group = "Buffer" },
  { "<leader>d", group = "Debug" },
  { "<leader>f", group = "Find" },
  { "<leader>g", group = "Git" },
  { "<leader>l", group = "LSP" },
  { "<leader>s", group = "Session" },
  { "<leader>t", group = "Terminal/Toggle" },
  { "<leader>x", group = "Diagnostics" },

  -- Buffer commands
  { "bc", desc = "Close current buffer" },
  { "bcc", desc = "Close all buffers" },
  { "bc1", desc = "Close all but current" },

  -- Find/Files (existing)
  { "<leader>ff", desc = "Find files" },
  { "<leader>fw", desc = "Live grep" },
  { "<leader>fb", desc = "Find buffers" },

  -- Git (existing)
  { "<leader>gg", desc = "LazyGit" },
  { "<leader>gb", desc = "Git blame line" },
  { "<leader>gd", desc = "Diff view" },

  -- LSP (existing)
  { "<leader>lf", desc = "Format buffer" },
  { "<leader>la", desc = "Code action" },
  { "<leader>rn", desc = "Rename symbol" },

  -- Session (existing)
  { "<leader>ss", desc = "Load session" },
  { "<leader>sS", desc = "Select session" },
  { "<leader>sl", desc = "Load last session" },

  -- General
  { "<leader>e", desc = "File explorer (Oil)" },
  { "<leader>w", desc = "Write file" },
  { "<leader>q", desc = "Quit" },
  { "<leader>o", desc = "Update & source" },
  { "<leader>tf", desc = "Toggle terminal" },
  { "<leader>xx", desc = "Toggle diagnostics" },

  -- LSP navigation (g prefix)
  { "g", group = "Go to" },
  { "gd", desc = "Go to definition" },
  { "gD", desc = "Go to declaration" },
  { "gr", desc = "Go to references" },
  { "gi", desc = "Go to implementation" },
  { "K", desc = "Hover documentation" },
})
