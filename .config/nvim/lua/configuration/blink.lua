return {
  -- blink.pairs
  {
    "saghen/blink.pairs",
    version = "*",
    dependencies = { "saghen/blink.lib" },
    build = function() require('blink.pairs').build():pwait(60000) end,
    opts = {
      mappings = {
        enabled = true,
        cmdline = true,
      },
      highlights = {
        enabled = true,
        cmdline = false,
        matchparen = {
          enabled = true,
          cmdline = false,
          include_surrounding = false,
        },
      },
    },
  },

  -- blink.cmp
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
      { "saghen/blink.lib", version = "*" },
      { "saghen/blink.download", version = "*" },
    },
    config = function()
      local cmp = require("blink.cmp")

      cmp.setup({
        sources = {
          default = { "lsp", "path", "buffer", "snippets" },
        },
        keymap = {
          ["<CR>"] = { "accept", "fallback" },
          ["<Tab>"] = { "select_next", "fallback" },
          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
          ["<C-.>"] = { "show", "hide" },
        },
        completion = {
          list = {
            selection = {
              preselect = true,
              auto_insert = true,
            },
          },
        },
        appearance = {
          use_nvim_cmp_as_default = true,
        },
        signature = {
          enabled = true,
          window = { border = "rounded" },
        },
      })
    end,
  },

  -- copilot (disabled, kept for future use)
  { "zbirenbaum/copilot.lua", lazy = true },
}
