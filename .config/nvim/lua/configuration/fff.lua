-- Create a visible cursor highlight for the selected row
-- (CursorLine may not be visible in some colorschemes like onedark)
vim.api.nvim_set_hl(0, 'FFFCursor', { link = 'Visual' })

-- Config must be passed directly to setup()
require("fff").setup({
  lazy_sync = true,
  prompt = '  ',
  layout = {
    prompt_position = 'top',
  },
  hl = {
    cursor = 'FFFCursor',
  },
  git = {
    status_text_color = true,
  },
  debug = {
    enabled = false,
    show_scores = false,
  },
})
