local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Compact ASCII header
dashboard.section.header.val = {
  "███╗   ██╗██╗   ██╗██╗███╗   ███╗",
  "████╗  ██║██║   ██║██║████╗ ████║",
  "██╔██╗ ██║██║   ██║██║██╔████╔██║",
  "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
  "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
  "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
}

-- Action buttons
dashboard.section.buttons.val = {
  dashboard.button("f", "  Find File", ":lua require('fff').find_files()<CR>"),
  dashboard.button("g", "  Live grep", ":lua require('fff').live_grep()<CR>"),
  dashboard.button("e", "  Open oil", ":lua require('oil').open_float()<CR>"),
  dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
  dashboard.button("q", "  Quit", ":qa<CR>"),
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

-- Optional: Footer (can show version or leave empty)
dashboard.section.footer.val = ""

alpha.setup(dashboard.config)
