return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")

    wk.setup({
      preset = "helix",
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

    wk.add({
      { "<leader>b", group = "Buffer" },
      { "<leader>d", group = "Debug" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>l", group = "LSP" },
      { "<leader>s", group = "Session" },
      { "<leader>t", group = "Terminal/Toggle" },
      { "<leader>hh", group = "Dashboard" },
      { "<leader>tt", group = "Tuxedo todo manager" },
      { "<leader>x", group = "Diagnostics" },

      { "bc", desc = "Close current buffer" },
      { "bcc", desc = "Close all buffers" },
      { "bc1", desc = "Close all but current" },

      { "<leader>ff", desc = "Find files" },
      { "<leader>fw", desc = "Live grep" },
      { "<leader>fb", desc = "Find buffers" },

      { "<leader>gg", desc = "LazyGit" },
      { "<leader>jj", desc = "Jujui" },
      { "<leader>gd", desc = "Diff view" },

      { "<leader>lf", desc = "Format buffer" },
      { "<leader>la", desc = "Code action" },
      { "<leader>rn", desc = "Rename symbol" },

      { "<leader>ss", desc = "Load session" },
      { "<leader>sS", desc = "Select session" },
      { "<leader>sl", desc = "Load last session" },

      { "<leader>e", desc = "File explorer (Oil)" },
      { "<leader>w", desc = "Write file" },
      { "<leader>q", desc = "Quit" },
      { "<leader>o", desc = "Update & source" },
      { "<leader>tf", desc = "Toggle terminal" },
      { "<leader>xx", desc = "Toggle diagnostics" },

      { "g", group = "Go to" },
      { "gd", desc = "Go to definition" },
      { "gD", desc = "Peekr: Definitions" },
      { "gR", desc = "Peekr: References" },
      { "K", desc = "Hover documentation" },
    })
  end,
}
