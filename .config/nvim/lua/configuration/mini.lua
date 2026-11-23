-- Icon provider for oil (`columns = { "icon" }`), fff (filetype icons) and
-- lualine. Keep this: without it, oil's icon column and fff's file icons break.
return {
  "nvim-mini/mini.icons",
  lazy = true,
  init = function()
    -- Mock nvim-web-devicons on top of mini.icons. Plugins that prefer
    -- devicons (fff) keep working without installing it.
    -- The require stays inside the closure so mini.icons itself loads lazily.
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
  -- mini.icons opts: use nerd-font's Rust gear for all Rust files. Both
  -- 'extension' and 'filetype' are overridden because 'file' resolution can
  -- reach either (extension for unknown-ftype files, filetype first for known
  -- ones). Glyphs are spelled as codepoints via nr2char: PUA literals in
  -- dotfiles tend to get eaten by shell/pipes/formatters (this file is proof).
  opts = {
    extension = { rs = { glyph = vim.fn.nr2char(0xf1617), hl = "MiniIconsOrange" } },
    filetype = { rust = { glyph = vim.fn.nr2char(0xf1617), hl = "MiniIconsOrange" } },
    file = { ["Cargo.toml"] = { glyph = vim.fn.nr2char(0xf1617), hl = "MiniIconsOrange" } },
  },
}
