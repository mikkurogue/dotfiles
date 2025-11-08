require('nvim-treesitter.configs').setup({
  ensure_installed = { 'c', 'lua', 'diff', 'javascript', 'zig', 'go', 'typescript', 'rust' },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
  autotag = { enable = true },
  fold = { enable = true }
})
