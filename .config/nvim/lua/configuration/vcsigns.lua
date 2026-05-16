return {
  "algmyr/vcsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "algmyr/vclib.nvim" },
  config = function()
    require("vcsigns").setup({
      target_commit = 1,
      signs = {
        text = {
          add = "│",
          change = "│",
          delete_below = "_",
          delete_above = "‾",
          delete_above_below = "‾",
        },
      },
    })

    local actions = require("vcsigns.actions")

    vim.keymap.set("n", "]c", function() actions.hunk_next(0, vim.v.count1); vim.cmd("normal! zz") end, { desc = "Next hunk" })
    vim.keymap.set("n", "[c", function() actions.hunk_prev(0, vim.v.count1); vim.cmd("normal! zz") end, { desc = "Prev hunk" })
    vim.keymap.set("n", "]C", function() actions.hunk_next(0, 9999); vim.cmd("normal! zz") end, { desc = "Last hunk" })
    vim.keymap.set("n", "[C", function() actions.hunk_prev(0, 9999); vim.cmd("normal! zz") end, { desc = "First hunk" })
    vim.keymap.set("n", "<leader>hu", function() actions.hunk_undo(0) end, { desc = "Undo hunk" })
    vim.keymap.set("v", "<leader>hu", function() actions.hunk_undo(0) end, { desc = "Undo hunks in selection" })
    vim.keymap.set("n", "<leader>hd", function() actions.toggle_hunk_diff(0) end, { desc = "Toggle inline diff" })
    vim.keymap.set("n", "<leader>hf", function() require("vcsigns.fold").toggle(0) end, { desc = "Fold non-hunk lines" })
    vim.keymap.set("n", "[r", function() actions.target_older_commit(0, vim.v.count1) end, { desc = "Diff against older commit" })
    vim.keymap.set("n", "]r", function() actions.target_newer_commit(0, vim.v.count1) end, { desc = "Diff against newer commit" })
  end,
}
