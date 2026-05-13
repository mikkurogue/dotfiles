local snipe = require("snipe")
snipe.setup({
    ui = {
      position = "center"
    }
  }
)

vim.keymap.set("n", "<leader>fb", snipe.open_buffer_menu)
