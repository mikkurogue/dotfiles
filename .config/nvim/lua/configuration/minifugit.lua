return {
  "vieitesss/minifugit.nvim",
  keys = {
    { "<leader>gs", desc = "Toggle git status" },
  },
  config = function()
    local mfg = require("minifugit")

    vim.keymap.set("n", "<leader>gs", function()
      if mfg.gsw and mfg.gsw.win and vim.api.nvim_win_is_valid(mfg.gsw.win) then
        vim.api.nvim_win_close(mfg.gsw.win, true)
        mfg.gsw.win = nil
      else
        mfg.status()
      end
    end)
  end,
}
