return {
  "leath-dub/snipe.nvim",
  keys = {
    { "<leader>fb", function() require("snipe").open_buffer_menu() end, desc = "Open buffer menu" },
  },
  opts = {
    ui = {
      position = "center",
    },
  },
}
