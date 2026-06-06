return {
  "mrdwarf7/lazyjui.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  opts = {},
  keys = {
    {
      "<leader>gj",
      function ()
        require("lazyjui").open()
      end
    }
  }
}
