return {
  "goolord/alpha-nvim",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local v = vim

    v.api.nvim_set_hl(0, "AlphaHeader", { fg = "#61afef", bold = true })
    v.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#e5c07b", bold = true })
    v.api.nvim_set_hl(0, "AlphaFooter", { fg = "#5c6370", italic = true })

    dashboard.section.header.val = {
      "",
      "        ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
      "        ████╗  ██║██║   ██║██║████╗ ████║",
      "        ██╔██╗ ██║██║   ██║██║██╔████╔██║",
      "        ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
      "        ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
      "        ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
      "",
      "      neovim  │    rust  │   zig  |   ts  ",
      "",
    }
    dashboard.section.header.opts = {
      position = "center",
      hl = "AlphaHeader",
    }

    local function btn(key, label, cmd)
      local b = dashboard.button(key, label, cmd)
      b.opts.hl_shortcut = "AlphaShortcut"
      return b
    end

    dashboard.section.buttons.val = {
      btn("e", "    File Explorer", ":lua require('oil').open_float()<CR>"),
      btn("f", "    Find Files", ":lua require('fff').find_files()<CR>"),
      btn("w", "  󰈞  Live Grep", ":lua require('fff').live_grep({ grep = { 'fuzzy' } })<CR>"),
      btn("g", "    LazyGit", ":LazyGit<CR>"),
      btn("t", "    Terminal", ":ToggleTerm<CR>"),
      btn("v", "    LazyJui", ":lua require('lazyjui').open()<CR>"),
      btn("q", "    Quit", ":qa<CR>"),
    }

    dashboard.section.buttons.opts = {
      spacing = 1,
      margin = { top = 1 },
    }

    dashboard.section.footer.val = function()
      local stats = require("lazy").stats()
      local nv = v.version()
      local rust = v.fn.system("rustc --version 2>/dev/null"):match("[%d.]+") or ""
      return {
        "",
        "    " .. stats.loaded .. "/" .. stats.count .. "  │    " .. nv.major .. "." .. nv.minor .. "." .. nv.patch .. "  │    " .. rust,
      }
    end
    dashboard.section.footer.opts = {
      position = "center",
      hl = "AlphaFooter",
    }

    alpha.setup(dashboard.config)
  end,
}
