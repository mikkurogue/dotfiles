return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    { "<leader>xx", function() require("trouble").toggle("diagnostics") end, desc = "Toggle Trouble diagnostics" },
  },
}
