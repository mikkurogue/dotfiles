return {
  "goolord/alpha-nvim",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      "    neovim btw",
      "    not vscode btw",
    }

    dashboard.section.buttons.val = {
      dashboard.button("e", "    File Explorer", ":lua require('oil').open_float()<CR>"),
      dashboard.button("f", "    Find Files", ":Fff<CR>"),
      dashboard.button("g", "    LazyGit", ":LazyGit<CR>"),
      dashboard.button("t", "    Terminal", ":ToggleTerm<CR>"),
      dashboard.button("j", "    LazyJui", ":lua require('lazyjui').open()<CR>"),
      dashboard.button("q", "    Quit", ":qa<CR>"),
    }

    dashboard.section.footer.val = ""

    alpha.setup(dashboard.config)
  end,
}
