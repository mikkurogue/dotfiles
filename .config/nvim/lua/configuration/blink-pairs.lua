require("blink.pairs").setup({
  mappings = {
    enabled = true,
    cmdline = true,
  },
  highlights = {
    enabled = true,
    cmdline = false,
    matchparen = {
      enabled = true,
      cmdline = false,
      include_surrounding = false,
    },
  },
})
