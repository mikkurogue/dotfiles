local v = vim

-- Basic keymaps vim specific
v.g.mapleader = " "
v.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
v.keymap.set('n', '<leader>w', ':write<CR>')
v.keymap.set('n', '<leader>q', ':quit<CR>')

v.keymap.set("n", "<Esc>", ":noh<CR>", {
  silent = true
})

-- v.keymap.set("n", "<leader>fw", function()
-- 	require('telescope.builtin').live_grep()
-- end)

-- trigger lazygit
v.keymap.set("n", "<leader>gg", ":LazyGit<CR>")

-- Telescope keymaps
v.keymap.set("n", "<leader>fb", function()
  require("telescope.builtin").buffers()
end, { desc = "Find buffers" })

v.keymap.set("n", "<leader>fw", function()
  require("telescope.builtin").live_grep()
end, { desc = "Live grep with ripgrep" })

v.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, { desc = "Find files" })

v.keymap.set("n", "<leader>ff", function()
  require('fff').find_files()
end, { desc = "Find files" })

-- format current buffer
v.keymap.set("n", "<leader>lf", v.lsp.buf.format)
v.keymap.set("n", "<leader>e", function()
  require("oil").open_float()
end)

v.keymap.set("n", "<leader>tf", ":ToggleTerm<CR>")


v.keymap.set("n", "<leader>xx", function()
    require("trouble").toggle("diagnostics")
  end,
  { desc = "Toggle Trouble diagnostics" }
)


-- lsp keymaps
v.keymap.set("n", "gd", v.lsp.buf.definition)
v.keymap.set("n", "gD", v.lsp.buf.declaration)
v.keymap.set("n", "gr", v.lsp.buf.references)
v.keymap.set("n", "gi", v.lsp.buf.implementation)
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

-- 🧠 Keymaps
v.keymap.set("n", "bc", "<cmd>bd<CR>", { desc = "Close current buffer" })
v.keymap.set("n", "bcc", close_all_buffers, { desc = "Close all buffers" })
v.keymap.set("n", "bc1", close_all_but_current, { desc = "Close all but current buffer" })

-- load the session for the current directory
v.keymap.set("n", "<leader>ss", function() require("persistence").load() end)
-- select a session to load
v.keymap.set("n", "<leader>sS", function() require("persistence").select() end)
-- load the last session
v.keymap.set("n", "<leader>sl", function() require("persistence").load({ last = true }) end)
