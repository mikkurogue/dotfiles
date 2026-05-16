return {
  "mikkurogue/peekr.nvim",
  event = "LspAttach",
  config = function()
    require("peekr").setup({
      height = 20,
      width = 0.75,
      border = "rounded",
      use_trouble_qf = false,
      winbar = { enabled = false },
      treesitter = { enable = true },
      list = { position = "right", width = 0.30 },
    })

    vim.keymap.set("n", "gd", "<CMD>Peekr definitions<CR>", { desc = "Peekr: Definitions" })
    vim.keymap.set("n", "gr", "<CMD>Peekr references<CR>", { desc = "Peekr: References" })
    vim.keymap.set("n", "gt", "<CMD>Peekr type_definitions<CR>", { desc = "Peekr: Type Definitions" })
    vim.keymap.set("n", "gi", "<CMD>Peekr implementations<CR>", { desc = "Peekr: Implementations" })
    vim.keymap.set("n", "gC", "<CMD>Peekr incoming_calls<CR>", { desc = "Peekr: Incoming Calls" })
    vim.keymap.set("n", "gO", "<CMD>Peekr outgoing_calls<CR>", { desc = "Peekr: Outgoing Calls" })
    vim.keymap.set("n", "gw", "<CMD>Peekr workspace_symbols<CR>", { desc = "Peekr: Workspace Symbols" })
  end,
}
