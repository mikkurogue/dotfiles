-- Basic vim settings
require("core.opts")

local v = vim

-- Plugins with native package manager
v.pack.add({
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/saghen/blink.cmp", },
  { src = "https://github.com/zbirenbaum/copilot.lua" },
  { src = "https://github.com/kdheepak/lazygit.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/echasnovski/mini.pairs" },
  { src = "https://github.com/echasnovski/mini.files" },
  { src = "https://github.com/folke/trouble.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
  { src = "https://github.com/dmtrKovalenko/fff.nvim" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/nvim-mini/mini.tabline" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/akinsho/toggleterm.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/j-hui/fidget.nvim",                     name = "fidget.nvim" },
  { src = "https://github.com/folke/persistence.nvim",                event = "BufReadPre" },
  { src = "https://github.com/ziglang/zig.vim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/folke/noice.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/rcarriga/nvim-notify" },
  { src = "https://github.com/doums/suit.nvim" },
})
require("notify").setup({
  background_colour = "#000000",
})

-- Add colorschemes
v.pack.add({
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
  { src = "https://github.com/catppuccin/nvim",              name = "catppuccin" },
  { src = "https://github.com/rose-pine/neovim",             name = "rose-pine" },
  { src = "https://github.com/rebelot/kanagawa.nvim" },
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/AlexvZyl/nordic.nvim" },
  { src = "https://github.com/EdenEast/nightfox.nvim" },
  { src = "https://github.com/tahayvr/matteblack.nvim" },
  { src = "https://github.com/stevedylandev/darkmatter-nvim" },
  { src = "https://github.com/bjarneo/firesky.nvim" },
  { src = "https://github.com/vyrx-dev/void.nvim" },
  { src = "https://github.com/olimorris/onedarkpro.nvim" }
})


require("configuration.fff")

v.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local spec = ev.data.spec
    if spec and spec.name == "fff.nvim" and ev.data.kind == "install" or ev.data.kind == "update" then
      local fff_path = v.fn.stdpath("data") .. "/site/pack/core/opt/fff.nvim"
      v.fn.jobstart({ "cargo", "build", "--release" }, {
        cwd = fff_path,
        on_exit = function(_, code)
          if code == 0 then
            v.notify("Cargo build finished successfully in " .. fff_path,
              v.log.levels.INFO)
          else
            v.notify("Cargo build failed with exit code " .. code, v.log.levels
              .ERROR)
          end
        end,
      })
    end
  end,
})

require("onedarkpro").setup({
  theme = "onedark",
})

require("catppuccin").setup({
  theme = "mocha"
})

local schemes = {
  "catppuccin",
  "tokyonight",
  "onedark",
  "matteblack",
  "void",
  "firesky",
  "rose-pine",
  "kanagawa",
  "nordic",
  "nightfox",
  "gruvbox",
  "darkmatter",
}

-- set colorscheme
v.cmd("colorscheme " .. schemes[7])

require("configuration.todo-comments")
require("configuration.mini")
require("configuration.persistence")
require("configuration.oil")
require("core.lsp")
-- require("core.lsp-breadcrumbs")
require("configuration.blink-cmp")
require("configuration.conform")
require("configuration.treesitter")
require("configuration.gitsigns")
require("configuration.toggleterm")
require("configuration.fidget")
require("configuration.lualine")

require("configuration.telescope")
require("configuration.tiny-inline-diagnostic")
require("configuration.noice")
require("configuration.suit")

-- get current git branch
function _G.GitBranch()
  -- check if gitsigns has set the branch name
  if v.b.gitsigns_head then
    return ' ' .. v.b.gitsigns_head
  end

  -- fallback: try running `git` directly
  local handle = io.popen('git rev-parse --abbrev-ref HEAD 2>/dev/null')
  if not handle then
    return ''
  end
  local branch = handle:read('*l')
  handle:close()
  if branch and branch ~= '' then
    return ' ' .. branch
  end
  return ''
end

-- Example if using statusline
-- v.o.statusline = "%f %m %r %h %{%v:lua.GitBranch()%} %= %{%v:lua.LspStatus()%} %l:%c"

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
