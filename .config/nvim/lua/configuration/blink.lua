return {
  -- blink.pairs
  -- v0.6+ needs a native library. Prefer downloading the prebuilt binary over a
  -- full `cargo build --release` (much faster, no toolchain needed at update
  -- time), and fall back to building only if the download fails.
  {
    "saghen/blink.pairs",
    version = "*",
    dependencies = { "saghen/blink.lib" },
    build = function()
      local ok = pcall(function() require("blink.pairs").download():pwait(60000) end)
      if not ok then
        require("blink.pairs").build():pwait(300000)
      end
    end,
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
          trigger = {
            show_on_insert_on_trigger_character = true,
          },
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
}
