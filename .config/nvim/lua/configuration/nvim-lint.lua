local lint = require("lint")

lint.linters_by_ft = {
  javascript = { "oxlint" },
  typescript = { "oxlint" },
  javascriptreact = { "oxlint" },
  typescriptreact = { "oxlint" },
  vue = { "oxlint" },
}

-- Show diagnostics on read/edit
vim.api.nvim_create_autocmd({ "BufReadPost", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})

-- Auto-fix with oxlint on save, then reload and re-lint
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue" },
  callback = function()
    local filename = vim.api.nvim_buf_get_name(0)
    if filename == "" then return end
    local result = vim.fn.system({ "oxlint", "--fix", filename })
    if vim.v.shell_error == 0 then
      vim.cmd("silent edit")
    end
    lint.try_lint()
  end,
})
