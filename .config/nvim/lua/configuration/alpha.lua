local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header = require("configuration.nvim-logo")
-- dashboard.section.header = require("configuration.rinnegan").header

-- Action buttons
dashboard.section.buttons.val = {
  dashboard.button("f", "  Find File", ":lua require('fff').find_files()<CR>"),
  dashboard.button("g", "  Live grep", ":lua require('fff').live_grep()<CR>"),
  dashboard.button("e", "  Open oil", ":lua require('oil').open_float()<CR>"),
  dashboard.button("q", "  Quit", ":qa<CR>"),
}

-- Layout configuration (minimal spacing)
dashboard.config.layout = {
  { type = "padding", val = 4 },
  dashboard.section.header,
  { type = "padding", val = 2 },
  dashboard.section.buttons,
  { type = "padding", val = 1 },
  dashboard.section.footer,
}

local function footer()
  local total_plugins = #vim.pack.get() 
  local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
  local version = vim.version()
  local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

  return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
end

dashboard.section.footer.val = footer()

alpha.setup(dashboard.config)
