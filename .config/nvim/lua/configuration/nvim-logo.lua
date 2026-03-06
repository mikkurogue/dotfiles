-- OneDark Pro colors for Neovim logo
-- Blue (top/left): #61afef
-- Green (bottom/right): #98c379

vim.api.nvim_set_hl(0, "NeovimLogoBlue", { fg = "#61afef" })
vim.api.nvim_set_hl(0, "NeovimLogoGreen", { fg = "#98c379" })

return {
  type = "text",
  val = {
    "      .            .      ",
    "    .,;'           :,.    ",
    "  .,;;;,,.         ccc;.  ",
    ".;c::::,,,'        ccccc: ",
    ".::cc::,,,,,.      cccccc.",
    ".cccccc;;;;;;'     llllll.",
    ".cccccc.,;;;;;;.   llllll.",
    ".cccccc  ';;;;;;'  oooooo.",
    "'lllllc   .;;;;;;;.oooooo'",
    "'lllllc     ,::::::looooo'",
    "'llllll      .:::::lloddd'",
    ".looool       .;::coooodo.",
    "  .cool         'ccoooc.  ",
    "    .co          .:o:.    ",
    "      .           .'      ",
  },
  opts = {
    position = "center",
    hl = {
      { { "NeovimLogoBlue", 0, 6 }, { "NeovimLogoGreen", 18, 27 } },
      { { "NeovimLogoBlue", 0, 8 }, { "NeovimLogoGreen", 18, 27 } },
      { { "NeovimLogoBlue", 0, 10 }, { "NeovimLogoGreen", 18, 27 } },
      { { "NeovimLogoBlue", 0, 12 }, { "NeovimLogoGreen", 18, 27 } },
      { { "NeovimLogoBlue", 0, 14 }, { "NeovimLogoGreen", 18, 27 } },
      { { "NeovimLogoBlue", 0, 16 }, { "NeovimLogoGreen", 18, 27 } },
      { { "NeovimLogoBlue", 0, 18 }, { "NeovimLogoGreen", 18, 27 } },
      { { "NeovimLogoBlue", 0, 20 }, { "NeovimLogoGreen", 18, 27 } },
      { { "NeovimLogoBlue", 0, 22 }, { "NeovimLogoGreen", 18, 27 } },
      { { "NeovimLogoBlue", 0, 24 }, { "NeovimLogoGreen", 14, 27 } },
      { { "NeovimLogoBlue", 0, 26 }, { "NeovimLogoGreen", 12, 27 } },
      { { "NeovimLogoBlue", 0, 27 }, { "NeovimLogoGreen", 10, 27 } },
      { { "NeovimLogoBlue", 0, 27 }, { "NeovimLogoGreen", 8, 27 } },
      { { "NeovimLogoBlue", 0, 27 }, { "NeovimLogoGreen", 6, 27 } },
      { { "NeovimLogoBlue", 0, 27 }, { "NeovimLogoGreen", 6, 27 } },
    },
  },
}
