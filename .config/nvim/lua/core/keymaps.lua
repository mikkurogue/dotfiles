local v = vim

-- remap hjkl to neio for colemak dh layout
-- vim.keymap.set("n", "n", "h")
-- vim.keymap.set("n", "e", "j")
-- vim.keymap.set("n", "i", "k")
-- vim.keymap.set("n", "o", "l")

-- Basic keymaps vim specific
-- mapleader is set in init.lua (must be set before any keymaps)
v.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
v.keymap.set('n', '<leader>w', ':write<CR>')
v.keymap.set('n', '<leader>q', ':quit<CR>')

v.keymap.set("n", "<Esc>", ":noh<CR>", {
  silent = true
})

-- format current buffer
v.keymap.set("n", "<leader>lf", v.lsp.buf.format)


-- lsp keymaps (gd, gD, gr, gi handled by Peekr — see configuration/peekr.lua)
v.keymap.set("n", "K", v.lsp.buf.hover)
v.keymap.set("n", "<C-k>", v.lsp.buf.signature_help)
v.keymap.set("n", "<leader>rn", v.lsp.buf.rename)
-- both leader ca and la for code action cause i use la but i should use ca
v.keymap.set("n", "<leader>la", v.lsp.buf.code_action)


-- Helper function to close all listed buffers
local function close_all_buffers()
  for _, bufnr in ipairs(v.api.nvim_list_bufs()) do
    if v.api.nvim_buf_is_loaded(bufnr) and v.bo[bufnr].buflisted then
      v.cmd("bd " .. bufnr)
    end
  end
end

-- Helper to close all but the current buffer
local function close_all_but_current()
  local current = v.api.nvim_get_current_buf()
  for _, bufnr in ipairs(v.api.nvim_list_bufs()) do
    if bufnr ~= current and v.api.nvim_buf_is_loaded(bufnr) and v.bo[bufnr].buflisted then
      v.cmd("bd " .. bufnr)
    end
  end
end

-- lsp keymaps
-- v.keymap.set("n", "gd", v.lsp.buf.definition)
-- v.keymap.set("n", "gr", v.lsp.buf.references)
-- v.keymap.set("n", "gi", v.lsp.buf.implementation)

-- Keymaps
v.keymap.set("n", "bc", "<cmd>bd<CR>", { desc = "Close current buffer" })
v.keymap.set("n", "bcc", close_all_buffers, { desc = "Close all buffers" })
v.keymap.set("n", "bc1", close_all_but_current, { desc = "Close all but current buffer" })

v.keymap.set("n", "<leader>tt", ":Tuxedo<CR>", { desc = "Open tuxedo todo manager" })
v.keymap.set("n", "<leader>hh", ":Alpha<CR>", { desc = "Open dashboard" })

-- load the session for the current directory
v.keymap.set("n", "<leader>ss", function() require("persistence").load() end)
-- select a session to load
v.keymap.set("n", "<leader>sS", function() require("persistence").select() end)
-- load the last session
v.keymap.set("n", "<leader>sl", function() require("persistence").load({ last = true }) end)
