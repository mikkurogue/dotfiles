return {
  -- All colorschemes lazy-loaded, only loaded when selected below or via :colorscheme
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    config = function()
      require("onedarkpro").setup()
    end,
  },
  {
    "IroncladDev/osmium",
    lazy = true,
    config = function()
      require("osmium").setup({
        integrations = {
          gitsigns = true,
          indent_blankline = true,
          fff = true,
          lualine = true,
          mini_icons = true,
          oil = true
        },
        transparent_bg = true,
        show_end_of_buffer = false,
      })
    end,
  },
  {
    "aejkatappaja/sora",
    lazy = true,
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
    lazy = true,
    config = function()
      require("kanagawa").setup({
        theme = "dragon",
        background = { dark = "dragon" },
      })
    end,
  },
}
