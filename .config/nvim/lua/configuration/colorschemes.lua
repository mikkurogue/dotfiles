return {
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    config = function()
      require("onedarkpro").setup()
    end,
  },
  {
    "IroncladDev/osmium",
    lazy = false,
    config = function()
      require("osmium").setup({
        integrations = {
          gitsigns = true,
          indent_blankline = true,
          fff = true,
          lualine = true,
        },
        transparent_bg = true,
        show_end_of_buffer = false,
      })
    end,
  },
  {
    "aejkatappaja/sora",
    lazy = false,
    config = function()
      require("sora").setup({
        transparent = true,
        italic = true,
        italic_comments = true,
      })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        theme = "dragon",
        background = { dark = "dragon" },
      })
      vim.cmd("colorscheme kanagawa")
    end,
  },
}
