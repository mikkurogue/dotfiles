-- Basic vim settings
require("core.opts")

local v = vim
v.g.mapleader = " "

-- Plugins
v.pack.add({
  -- Colorschemes
  { src = "https://github.com/olimorris/onedarkpro.nvim" },
  { src = "https://github.com/IroncladDev/osmium" },

  -- LSP, Diagnostics & Formatting
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
  { src = "https://github.com/j-hui/fidget.nvim",                     name = "fidget.nvim" },
  { src = "https://github.com/folke/trouble.nvim" },
  { src = "https://github.com/mikkurogue/peekr.nvim" },

  -- Completion & Pairs (blink)
  {src = "https://github.com/saghen/blink.lib"},
  { src = "https://github.com/saghen/blink.cmp" },
  { src = "https://github.com/saghen/blink.pairs" },
  { src = "https://github.com/saghen/blink.download" },
  { src = "https://github.com/zbirenbaum/copilot.lua" },

  -- Treesitter
  { src = "https://github.com/romus204/tree-sitter-manager.nvim" },

  -- Debugging (DAP)
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },

  -- Fuzzy Finding & Navigation
  { src = "https://github.com/dmtrKovalenko/fff.nvim" },
  { src = "https://github.com/leath-dub/snipe.nvim" },

  -- File Explorer
  { src = "https://github.com/stevearc/oil.nvim" },

  -- Git & VCS
  { src = "https://github.com/kdheepak/lazygit.nvim" },
  { src = "https://github.com/algmyr/vclib.nvim" },
  { src = "https://github.com/algmyr/vcsigns.nvim" },
  { src = "https://github.com/vieitesss/minifugit.nvim" },
  { src = "https://github.com/trixnz/sops.nvim" },

  -- UI & Appearance
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/akinsho/bufferline.nvim" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },

  { src = "https://github.com/folke/noice.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/rcarriga/nvim-notify" },
  { src = "https://github.com/doums/suit.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },

  -- Session & Workflow
  { src = "https://github.com/folke/persistence.nvim",                 event = "BufReadPre" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/akinsho/toggleterm.nvim" },

  -- Language-specific
  { src = "https://github.com/vuki656/package-info.nvim" },
  { src = "https://github.com/saecki/crates.nvim" },
  { src = "https://github.com/lewis6991/async.nvim" },


})

-- PackChanged hooks
v.api.nvim_create_autocmd("PackChanged", {
  callback = function(event)
    if event.data.updated then
      require("fff.download").download_or_build_binary()
    end
  end,
})


-- Colorscheme
require("onedarkpro").setup()
require("osmium").setup({
  integrations = {
    gitsigns = true,
    indent_blankline = true,
    fff = true,
  },
  transparent_bg = true,
  show_end_of_buffer = false,
})

local schemes = {
  "onedark",
  "onelight",
  "onedark_dark",
  "onedark_vivid",
  "osmium",
}
v.cmd("colorscheme " .. schemes[1])

-- LSP, Diagnostics & Formatting
require("core.lsp")
require("configuration.conform")
require("configuration.tiny-inline-diagnostic")
require("configuration.fidget")
require("configuration.peekr")

-- Completion & Pairs (blink)
require("configuration.blink")

-- Treesitter
require("configuration.treesitter")

-- Debugging (DAP) - deferred to first use
v.api.nvim_create_autocmd("User", {
  pattern = "DapLoad",
  once = true,
  callback = function()
    require("configuration.dap")
  end,
})
-- Create lazy-loading commands for DAP
for _, cmd in ipairs({ "DapContinue", "DapToggleBreakpoint" }) do
  v.api.nvim_create_user_command(cmd, function()
    v.api.nvim_del_user_command(cmd)
    v.api.nvim_exec_autocmds("User", { pattern = "DapLoad" })
    if cmd == "DapContinue" then
      require("dap").continue()
    else
      require("dap").toggle_breakpoint()
    end
  end, { desc = "Lazy-load DAP and run " .. cmd })
end
-- Defer <leader>d keymaps until DAP loads
v.keymap.set("n", "<leader>dc", function()
  v.api.nvim_exec_autocmds("User", { pattern = "DapLoad" })
  require("dap").continue()
end, { desc = "Continue/Start (loads DAP)" })
v.keymap.set("n", "<leader>db", function()
  v.api.nvim_exec_autocmds("User", { pattern = "DapLoad" })
  require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint (loads DAP)" })
v.keymap.set("n", "<F5>", function()
  v.api.nvim_exec_autocmds("User", { pattern = "DapLoad" })
  require("dap").continue()
end, { desc = "Debug: Continue (loads DAP)" })

-- Fuzzy Finding & Navigation
require("configuration.fff")
require("configuration.snipe")

-- File Explorer
require("configuration.oil")

-- Git & VCS
require("configuration.vcsigns")
require("configuration.minifugit")

-- UI & Appearance
require("notify").setup({ background_colour = "#000000" })
require("configuration.lualine")
require("bufferline").setup({
  options = {
    indicator = { style = "underline" },
    separator_style = "slant",
  },
})
require("configuration.mini")
require("ibl").setup()
require("configuration.noice")
require("configuration.suit")
require("configuration.which-key")

-- Session & Workflow
require("configuration.persistence")
require("configuration.todo-comments")
require("configuration.toggleterm")

-- Language-specific (deferred to relevant filetypes)
v.api.nvim_create_autocmd("BufRead", {
  pattern = "package.json",
  once = true,
  callback = function()
    require("package-info").setup()
  end,
})
v.api.nvim_create_autocmd("BufRead", {
  pattern = "Cargo.toml",
  once = true,
  callback = function()
    require("crates").setup()
  end,
})


require("core.keymaps")
function _G.GitBranch()
  if v.b.gitsigns_head then
    return " " .. v.b.gitsigns_head
  end
  local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
  if not handle then return "" end
  local branch = handle:read("*l")
  handle:close()
  if branch and branch ~= "" then
    return " " .. branch
  end
  return ""
end

v.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local bufnr = v.api.nvim_get_current_buf()
    local bufname = v.api.nvim_buf_get_name(bufnr)
    local buftype = v.api.nvim_buf_get_option(bufnr, "buftype")
    if bufname ~= "" and buftype == "" then
      for _, b in ipairs(v.api.nvim_list_bufs()) do
        if v.api.nvim_buf_is_loaded(b)
            and v.bo[b].buflisted
            and b ~= bufnr
            and v.api.nvim_buf_get_name(b) == "" then
          v.cmd("bd " .. b)
        end
      end
    end
  end,
})
