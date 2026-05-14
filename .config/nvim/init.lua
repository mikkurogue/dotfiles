-- Basic vim settings
require("core.opts")

local v = vim
v.g.mapleader = " "

-- Bootstrap lazy.nvim
local lazypath = v.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not v.uv.fs_stat(lazypath) then
  v.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
v.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Colorschemes (load eagerly since we need them at startup)
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    config = function()
      require("onedarkpro").setup()
    end,
  },
  {
    "IroncladDev/osmium",
    lazy = false,
    config = function()
      require("osmium").setup({
        integrations = {
          gitsigns = true,
          indent_blankline = true,
          fff = true,
          lualine = true,
        },
        transparent_bg = true,
        show_end_of_buffer = false,
      })
    end,
  },
  {
    "aejkatappaja/sora",
    lazy = false,
    config = function()
      require("sora").setup({
        transparent = true,
        italic = true,
        italic_comments = true,
      })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        theme = "dragon",
        background = { dark = "dragon" },
      })
      v.cmd("colorscheme kanagawa")
    end,
  },

  -- LSP, Diagnostics & Formatting
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("core.lsp")
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    config = function()
      require("configuration.conform")
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    config = function()
      require("configuration.tiny-inline-diagnostic")
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    config = function()
      require("configuration.fidget")
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", function() require("trouble").toggle("diagnostics") end, desc = "Toggle Trouble diagnostics" },
    },
  },
  {
    "mikkurogue/peekr.nvim",
    event = "LspAttach",
    config = function()
      require("configuration.peekr")
    end,
  },

  -- Completion & Pairs (blink)
  { "saghen/blink.lib", version = "*", lazy = true },
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
      "saghen/blink.lib",
      "saghen/blink.pairs",
      "saghen/blink.download",
    },
    config = function()
      require("configuration.blink")
    end,
  },
  { "saghen/blink.pairs", version = "*", lazy = true },
  { "saghen/blink.download", version = "*", lazy = true },
  { "zbirenbaum/copilot.lua", lazy = true },

  -- Treesitter
  {
    "romus204/tree-sitter-manager.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("configuration.treesitter")
    end,
  },

  -- Debugging (DAP) - lazy loaded on commands/keys
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    cmd = { "DapContinue", "DapToggleBreakpoint", "DapInstallAdapters", "DapHealthCheck" },
    keys = {
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue/Start" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
    },
    config = function()
      require("configuration.dap")
    end,
  },
  { "rcarriga/nvim-dap-ui", lazy = true },
  { "theHamsta/nvim-dap-virtual-text", lazy = true },
  { "nvim-neotest/nvim-nio", lazy = true },

  -- Fuzzy Finding & Navigation
  {
    "dmtrKovalenko/fff.nvim",
    keys = {
      { "<leader>ff", function() require("fff").find_files() end, desc = "Find files" },
      { "<leader>fw", function() require("fff").live_grep({ grep = { "fuzzy" } }) end, desc = "Live grep with fff" },
    },
    config = function()
      require("configuration.fff")
    end,
    build = function()
      require("fff.download").download_or_build_binary()
    end,
  },
  {
    "leath-dub/snipe.nvim",
    keys = {
      { "<leader>m", desc = "Open buffer menu" },
    },
    config = function()
      require("configuration.snipe")
    end,
  },

  -- File Explorer
  {
    "stevearc/oil.nvim",
    keys = {
      { "<leader>e", function() require("oil").open_float() end, desc = "Open Oil file explorer" },
    },
    cmd = "Oil",
    config = function()
      require("configuration.oil")
    end,
  },

  -- Git & VCS
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = {
      { "<leader>gg", ":LazyGit<CR>", desc = "Open LazyGit" },
    },
  },
  {
    "algmyr/vclib.nvim",
    lazy = true,
  },
  {
    "algmyr/vcsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "algmyr/vclib.nvim" },
    config = function()
      require("configuration.vcsigns")
    end,
  },
  {
    "vieitesss/minifugit.nvim",
    keys = {
      { "<leader>gs", desc = "Toggle git status" },
    },
    config = function()
      require("configuration.minifugit")
    end,
  },
  {
    "trixnz/sops.nvim",
    event = "BufReadPre",
    config = true,
  },

  -- UI & Appearance
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("configuration.lualine")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          indicator = { style = "underline" },
          separator_style = "slant",
        },
      })
    end,
  },
  {
    "nvim-mini/mini.icons",
    lazy = true,
    init = function()
      -- Make mini.icons the default icon provider before it loads
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
    config = function()
      require("configuration.mini")
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("configuration.noice")
    end,
  },
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = { background_colour = "#000000" },
  },
  {
    "doums/suit.nvim",
    event = "VeryLazy",
    config = function()
      require("configuration.suit")
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("configuration.which-key")
    end,
  },

  -- Session & Workflow
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("configuration.persistence")
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("configuration.todo-comments")
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = {
      { "<leader>tf", ":ToggleTerm<CR>", desc = "Toggle terminal" },
    },
    config = function()
      require("configuration.toggleterm")
    end,
  },

  -- Language-specific
  {
    "vuki656/package-info.nvim",
    event = "BufRead package.json",
    config = function()
      require("package-info").setup()
    end,
  },
  {
    "saecki/crates.nvim",
    event = "BufRead Cargo.toml",
    config = function()
      require("crates").setup()
    end,
  },
  { "lewis6991/async.nvim", lazy = true },
}, {
  -- lazy.nvim options
  checker = {
    enabled = false,  -- don't auto-check for updates (handled by GH workflow)
  },
  change_detection = {
    notify = false,
  },
})

-- Keymaps (non-plugin keymaps that aren't handled by lazy keys)
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
