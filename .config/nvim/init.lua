-- Basic vim settings
require("core.opts")

local v = vim
-- Plugins with native package manager
v.pack.add({
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/saghen/blink.cmp", },
  { src = "https://github.com/akinsho/bufferline.nvim", },
  { src = "https://github.com/zbirenbaum/copilot.lua" },
  { src = "https://github.com/kdheepak/lazygit.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/folke/trouble.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
  { src = "https://github.com/dmtrKovalenko/fff.nvim" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/akinsho/toggleterm.nvim" },
  { src = "https://github.com/algmyr/vclib.nvim" },
  { src = "https://github.com/algmyr/vcsigns.nvim" },
  { src = "https://github.com/julienvincent/hunk.nvim" },
  { src = "https://github.com/sindrets/diffview.nvim" },
  { src = "https://github.com/j-hui/fidget.nvim",                     name = "fidget.nvim" },
  { src = "https://github.com/folke/persistence.nvim",                event = "BufReadPre" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/folke/noice.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/rcarriga/nvim-notify" },
  { src = "https://github.com/doums/suit.nvim" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
  { src = "https://github.com/vyfor/cord.nvim" },
  { src = "https://github.com/saghen/blink.download" },
  { src = "https://github.com/saghen/blink.pairs" },
  { src = "https://github.com/vuki656/package-info.nvim" },
  { src = "https://github.com/goolord/alpha-nvim" },
  { src = "https://github.com/kevinhwang91/promise-async" },
  { src=  "https://github.com/saecki/crates.nvim" },
  -- Debugging (DAP)
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
  { src = "https://github.com/nvim-neotest/nvim-nio" }, -- required by nvim-dap-ui
  -- Which-key for keybind helper
  { src = "https://github.com/folke/which-key.nvim" },
})

require("notify").setup({
  background_colour = "#000000",
})

-- Add colorschemes
v.pack.add({
  { src = "https://github.com/IroncladDev/osmium" },
  { src = "https://github.com/olimorris/onedarkpro.nvim" },
})

require("configuration.fff")

require("package-info").setup()
require("crates").setup()

v.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local spec = ev.data.spec

    if spec and spec.name == "fff.nvim" and (ev.data.kind == "install" or ev.data.kind == "update") then
      require('fff.download').download_or_build_binary()
    end

    if spec and spec.name == "blink.cmp" and (ev.data.kind == "install" or ev.data.kind == "update") then
      local blink_cmp_path = v.fn.stdpath("data") .. "/site/pack/core/opt/blink.cmp"
      v.fn.jobstart({ "cargo", "build", "--release" }, {
        cwd = blink_cmp_path,
        on_exit = function(_, code)
          if code == 0 then
            v.notify("[blink.cmp] Cargo build finished successfully in " .. blink_cmp_path,
              v.log.levels.INFO)
          else
            v.notify("[blink.cmp] Cargo build failed with exit code " .. code, v.log.levels
              .ERROR)
          end
        end,
      })
    end

    if spec and spec.name == "blink.pairs" and (ev.data.kind == "install" or ev.data.kind == "update") then
      local blink_pairs_path = v.fn.stdpath("data") .. "/site/pack/core/opt/blink.pairs"
      v.fn.jobstart({ "cargo", "build", "--release" }, {
        cwd = blink_pairs_path,
        on_exit = function(_, code)
          if code == 0 then
            v.notify("[blink.pairs] Cargo build finished successfully in " .. blink_pairs_path,
              v.log.levels.INFO)
          else
            v.notify("[blink.pairs] Cargo build failed with exit code " .. code, v.log.levels.ERROR)
          end
        end,
      })
    end
  end,
})

v.api.nvim_create_autocmd('PackChanged', {
  callback = function(opts)
    if opts.data.spec.name == 'cord.nvim' and opts.data.kind == 'update' then
      v.cmd 'Cord update'
    end
  end
})

require("cord").setup({
  display = {
    theme = "atom",
    flavor = "dark",
  },
  idle = {
    enabled = false,
  },
  text = {
    workspace = "Neovim btw"
  }
  
})

require("ibl").setup()

require("onedarkpro").setup({
  theme = "onedark",
})

local schemes = {
  "onedark",
  "osmium",
}


-- set colorscheme
v.cmd("colorscheme " .. schemes[1])

require("configuration.todo-comments")
require("configuration.mini")
require("configuration.persistence")
require("configuration.oil")
require("core.lsp")
require("configuration.blink-cmp")
require("configuration.blink-pairs")
require("bufferline").setup({
  options = {
    indicator = {
      style = "underline",
    },
    separator_style = "slant",
  }
})
require("configuration.conform")
require("configuration.vcsigns")
require("configuration.hunk")
require("configuration.diffview")
require("configuration.toggleterm")
require("configuration.fidget")
require("configuration.lualine")

require("osmium").setup({
  integrations = {
    gitsigns = true,
    telescope = true,
    indent_blankline = true,
    fff = true,
  },
  transparent_bg = true,     -- whether to use a transparent background
  show_end_of_buffer = false, -- whether to show the end of buffer
})


require("configuration.telescope")
require("configuration.tiny-inline-diagnostic")

require("configuration.noice")
require("configuration.suit")
-- require("configuration.alpha")
require("configuration.which-key")
require("configuration.dap")

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
