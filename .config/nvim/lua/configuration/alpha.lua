local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- ASCII header
-- dashboard.section.header.val = {
--   [[                                                                   ]],
--   [[ ███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄   ]],
--   [[ ███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄ ]],
--   [[ ███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
--   [[ ███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
--   [[ ███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
--   [[ ███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███ ]],
--   [[ ███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███ ]],
--   [[  ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀  ]],
--   [[                                                                   ]],
-- }

dashboard.section.header = require("configuration.nvim-logo")
-- dashboard.section.header = require("configuration.rinnegan").header
-- dashboard.section.header = require("configuration.mangekyo").header

-- Action buttons
dashboard.section.buttons.val = {
  dashboard.button("f", "  Find File", ":lua require('fff').find_files()<CR>"),
  dashboard.button("g", "  Live grep", ":lua require('fff').live_grep()<CR>"),
  dashboard.button("e", "  Open oil", ":lua require('oil').open_float()<CR>"),
  dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
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

dashboard.section.footer.val = os.date("%Y-%m-%d %H:%M:%S")

alpha.setup(dashboard.config)
