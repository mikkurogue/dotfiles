-- -- COPILOT CORE
-- Disable copilot cause its fucking annoying
-- require("copilot").setup({
--   suggestion = {
--     enabled = true,    -- enable ghost text
--     auto_trigger = true, -- show suggestions automatically
--     keymap = {
--       accept = "<C-J>", -- accept suggestion
--       accept_line = false,
--     },
--   },
--   panel = { enabled = false },
-- })


local cmp = require('blink.cmp')

-- BLINK CONFIG (load AFTER copilot_cmp.setup)
cmp.setup({
  sources = {
    default = {
      'lsp', 'path', 'buffer', 'snippets'
    }
  },
  keymap = {
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = {
      "select_next",
      "fallback",
    },
    ["<S-Tab>"] = {
      "select_prev",
      "snippet_backward",
      "fallback",
    },
    -- Same as above, copilot is fucking annoying
    -- ["<C-j>"] = {
    --   "accept",
    --   function() -- Then try copilot if visible
    --     local ok, copilot = pcall(require, "copilot.suggestion")
    --     if ok and copilot.is_visible() then
    --       copilot.accept()
    --       return true -- stop the chain
    --     end
    --   end,
    --   "snippet_forward", -- Try snippet forward
    --   "fallback",     -- Finally fallback to default behavior
    -- },
    ["<C-.>"] = { "show", "hide" },
  },
  completion = {
    list = {
      selection = {
        preselect = true,
        auto_insert = true,
      }
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

require("blink.pairs").setup({
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
})
