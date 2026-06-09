return {
  "mrdwarf7/lazyjui.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {},
  keys = {
    {
      "<leader>jj",
      function()
        require("lazyjui").open()
      end,
      desc = "Open Jujui",
    },
  },
}
