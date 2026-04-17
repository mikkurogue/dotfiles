local v = vim

-- temporarily disable the ruler
v.o.ruler = false

v.o.number = true
v.o.relativenumber = true
v.o.signcolumn = "yes"
v.o.wrap = false
v.o.tabstop = 2
v.o.shiftwidth = 2
v.o.swapfile = false
v.o.winborder = "rounded"
v.o.laststatus = 3
v.o.clipboard = "unnamedplus"
v.o.updatetime = 50 -- milliseconds
v.diagnostic.config({ virtual_text = false })
v.o.incsearch = true
v.o.undofile = true
v.o.termguicolors = true
v.o.smartindent = true

v.o.guicursor = "n-v-c:block-blinkwait700-blinkon400-blinkoff250,i-ci-ve:ver25-blinkwait700-blinkon400-blinkoff250,r-cr-o:hor20-blinkwait700-blinkon400-blinkoff250"

v.o.scrolloff = 8

v.o.expandtab = true
-- v.o.foldenable = true
-- v.o.foldcolumn = "1"  -- show fold indicators in the sign column
-- v.o.foldlevel = 99    -- start with all folds open
-- v.o.foldlevelstart = 99

-- Increase redrawtime so async treesitter parsing can finish after large jumps
v.o.redrawtime = 10000

-- Disable treesitter for very large files, fall back to regex syntax
local large_file_bytes = 5 * 1024 * 1024 -- 5MB
local large_file_lines = 50000

v.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local buf = args.buf
    local ok, stats = pcall(v.uv.fs_stat, v.api.nvim_buf_get_name(buf))
    local filesize = ok and stats and stats.size or 0
    local linecount = v.api.nvim_buf_line_count(buf)

    if filesize > large_file_bytes or linecount > large_file_lines then
      v.treesitter.stop(buf)
      v.bo[buf].syntax = "ON"
    end
  end,
})

v.o.ignorecase = true
v.o.incsearch = true
v.o.hlsearch = true

-- highlight on yank
v.api.nvim_create_autocmd("TextYankPost", {
  group = v.api.nvim_create_augroup("HighlightYank", {
    clear = true
  }),
  pattern = "*",
  callback = function()
    v.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 200
    })
  end
})
