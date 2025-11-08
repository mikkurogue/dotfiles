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
v.o.foldenable = true                            -- make sure folds are enabled
v.o.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
v.o.foldcolumn = "auto:1"
v.o.foldmethod = "expr"                          -- folding, set to "expr" for treesitter based folding
v.o.foldlevel = 99

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
