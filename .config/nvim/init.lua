-- Basic vim settings
require("core.opts")

local v = vim

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

  -- File Explorer
  { src = "https://github.com/stevearc/oil.nvim" },

  -- Git & VCS
  { src = "https://github.com/kdheepak/lazygit.nvim" },
  { src = "https://github.com/algmyr/vclib.nvim" },
  { src = "https://github.com/algmyr/vcsigns.nvim" },

  -- UI & Appearance
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/akinsho/bufferline.nvim" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
  { src = "https://github.com/goolord/alpha-nvim" },
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

  -- Misc
  { src = "https://github.com/vyfor/cord.nvim" },
})

-- PackChanged hooks
v.api.nvim_create_autocmd("PackChanged", {
  callback = function(event)
    if event.data.updated then
      require("fff.download").download_or_build_binary()
    end
  end,
})

v.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local spec = ev.data.spec
    if not spec then return end

    -- Cargo build for blink plugins
    local blink_plugins = { ["blink.cmp"] = true, ["blink.pairs"] = true }
    if blink_plugins[spec.name] and (ev.data.kind == "install" or ev.data.kind == "update") then
      local path = v.fn.stdpath("data") .. "/site/pack/core/opt/" .. spec.name
      v.fn.jobstart({ "cargo", "build", "--release" }, {
        cwd = path,
        on_exit = function(_, code)
          if code == 0 then
            local lib_dir = path .. "/lib"
            vim.fn.mkdir(lib_dir, "p")
            vim.uv.fs_copyfile(
              path .. "/target/release/lib" .. spec.name:gsub("%.", "_") .. "_fuzzy.dylib",
              lib_dir .. "/lib" .. spec.name:gsub("%.", "_") .. "_fuzzy.dylib"
            )
            v.notify("[" .. spec.name .. "] Cargo build finished successfully", v.log.levels.INFO)
          else
            v.notify("[" .. spec.name .. "] Cargo build failed with exit code " .. code, v.log.levels.ERROR)
          end
        end,
      })
    end

    -- Cord update hook
    if spec.name == "cord.nvim" and ev.data.kind == "update" then
      v.cmd("Cord update")
    end
  end,
})

-- Colorscheme
require("onedarkpro").setup()
require("osmium").setup({
  integrations = {
    gitsigns = true,
    telescope = false,
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

-- Debugging (DAP)
require("configuration.dap")

-- Fuzzy Finding & Navigation
require("configuration.fff")

-- File Explorer
require("configuration.oil")

-- Git & VCS
require("configuration.vcsigns")

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
require("configuration.alpha")
require("configuration.noice")
require("configuration.suit")
require("configuration.which-key")

-- Session & Workflow
require("configuration.persistence")
require("configuration.todo-comments")
require("configuration.toggleterm")

-- Language-specific
require("package-info").setup()
require("crates").setup()

-- Misc
require("cord").setup({
  display = {
    theme = "atom",
    flavor = "dark",
  },
  idle = { enabled = false },
  text = { workspace = "Neovim btw" },
})

-- Utilities
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

require("core.keymaps")
