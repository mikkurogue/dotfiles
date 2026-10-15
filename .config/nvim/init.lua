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

-- Colorscheme (see configuration/theme.lua for options)
v.o.background = "dark"
v.cmd("colorscheme gruvbox")

-- Hide the initial empty [No Name] buffer from the buffer list.
-- One-shot: the old implementation re-ran a full buffer sweep on every
-- BufEnter, which was pure overhead (and a likely contributor to oil's
-- double-buffer weirdness). Unlisting is non-destructive - the buffer stays
-- usable, it just doesn't clutter :ls.
v.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local buf = v.api.nvim_get_current_buf()
    if v.api.nvim_buf_get_name(buf) == "" and v.bo[buf].buftype == "" then
      v.bo[buf].buflisted = false
    end
  end,
})
