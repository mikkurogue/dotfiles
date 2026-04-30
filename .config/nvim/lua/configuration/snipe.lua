local snipe = require("snipe")
snipe.setup()

vim.keymap.set("n", "<leader>m", snipe.open_buffer_menu)
