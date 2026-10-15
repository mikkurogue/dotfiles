-- Icon provider for oil (`columns = { "icon" }`), fff (filetype icons) and
-- heirline. Keep this: without it, oil's icon column and fff's file icons break.
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
  opts = {},
}
