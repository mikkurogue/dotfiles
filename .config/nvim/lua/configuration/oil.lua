return {
  {
    "stevearc/oil.nvim",
    keys = {
      { "<leader>e", function() require("oil").open_float() end, desc = "Open Oil file explorer" },
    },
    cmd = "Oil",
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        win_options = {
          signcolumn = "yes:2",
        },
        keymaps = {
          ["q"] = "actions.close",
          ["esc"] = "actions.close",
          ["<leader>e"] = "actions.close",
          ["<BS>"] = "actions.parent",
          ["<leader><BS>"] = "actions.parent",
          ["h"] = "actions.parent",
          ["l"] = "actions.select",
          ["<CR>"] = "actions.select",
          ["<leader>r"] = "actions.refresh",
          ["gr"] = "actions.refresh",
          ["<leader>."] = "actions.toggle_hidden",
        },
        view_options = {
          show_hidden = true,
          highlight_opened_files = "name",
        },
        lsp_file_methods = {
          enabled = true,
          timeout_ms = 1000,
        },
        columns = { "icon" },
        float = {
          padding = 2,
          border = "rounded",
          max_width = 0.5,
          max_height = 0.5,
          win_options = {
            winblend = 0,
            winhighlight = "NormalFloat:Normal",
          },
        },
        open = "float",
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "oil",
        callback = function()
          vim.opt_local.fillchars = { eob = " " }
        end,
      })
    end,

  },
  {
    "refractalize/oil-git-status.nvim",

    config = function()
      require("oil-git-status").setup({
        show_ignored = true,
        symbols = {
          index = {
            ["M"] = "",
            ["A"] = "",
            ["D"] = "",
            ["R"] = "",
            ["C"] = "",
            ["T"] = "",
            ["U"] = "",
            ["?"] = "",
            ["!"] = "",
            [" "] = " ",
          },
          working_tree = {
            ["M"] = "",
            ["A"] = "",
            ["D"] = "",
            ["R"] = "",
            ["C"] = "",
            ["T"] = "",
            ["U"] = "",
            ["?"] = "",
            ["!"] = "",
            [" "] = " ",
          },
        },
      })
    end,
  }
}
