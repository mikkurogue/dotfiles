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

v.o.scrolloff = 8

v.o.expandtab = true
-- v.o.foldenable = true
-- v.o.foldcolumn = "1"  -- show fold indicators in the sign column
-- v.o.foldlevel = 99    -- start with all folds open
-- v.o.foldlevelstart = 99

-- Enable treesitter highlighting for all supported filetypes
v.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    -- Try to start treesitter highlighting if a parser exists
    pcall(v.treesitter.start, args.buf)
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
