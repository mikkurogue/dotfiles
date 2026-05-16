return {
  "dmtrKovalenko/fff.nvim",
  keys = {
    { "<leader>ff", function() require("fff").find_files() end, desc = "Find files" },
    { "<leader>fw", function() require("fff").live_grep({ grep = { "fuzzy" } }) end, desc = "Live grep with fff" },
  },
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  config = function()
    vim.api.nvim_set_hl(0, "FFFCursor", { link = "Visual" })

    require("fff").setup({
      lazy_sync = true,
      prompt = "  ",
      layout = { prompt_position = "top" },
      hl = { cursor = "FFFCursor" },
      git = { status_text_color = true },
      debug = { enabled = false, show_scores = false },
    })
  end,
}
