-- Basic vim settings
require("core.opts")

local v = vim
v.g.mapleader = " "
v.g.maplocalleader = " "

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

-- Each file in lua/configuration/ returns a lazy.nvim plugin spec (or list of specs).
-- lazy.nvim auto-imports them all.
require("lazy").setup("configuration", {
  checker = {
    enabled = false, -- don't auto-check for updates (handled by GH workflow)
  },
  change_detection = {
    notify = false,
  },
})

-- Non-plugin keymaps
require("core.keymaps")

-- Global helpers
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

-- Colorscheme
-- Change the index to switch colorscheme, or use a builtin like "vim"
local schemes = {
  "vim",          -- 1: nvim dark (builtin, no plugin needed)
  "onedark",      -- 2: onedarkpro
  "osmium",       -- 3: osmium
  "sora",         -- 4: sora
  "kanagawa",     -- 5: kanagawa dragon
}
v.o.background = "dark"
v.cmd("colorscheme " .. schemes[5])

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
