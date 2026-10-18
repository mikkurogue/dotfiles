-- Turns Neovim's global buffers into tab-local buffers, so each tab keeps its
-- own buffer set and `:bnext`/`:bprev` cycle only within the current tab.
-- Must load at startup (not lazy): it has to hook the buffer and tab events
-- before anything else opens a buffer.
return {
  "backdround/tabscope.nvim",
  lazy = false,
  config = function()
    require("tabscope").setup({})

    -- Drop the current buffer's tab-local scope, restoring it as a global buffer.
    vim.keymap.set("n", "<M-o>", require("tabscope").remove_tab_buffer, {
      desc = "Tabscope: Remove tab-local buffer",
    })
  end,
}