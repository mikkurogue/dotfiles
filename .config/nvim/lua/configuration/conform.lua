local util = require("conform.util")
local biome_root = util.root_file({ "biome.json", "biome.jsonc" })
local prettier_root = util.root_file({
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.json5",
  ".prettierrc.yml",
  ".prettierrc.yaml",
  ".prettierrc.js",
  ".prettierrc.cjs",
  "prettier.config.js",
  "prettier.config.cjs",
})

local function formatters_for(bufnr)
  if biome_root(bufnr) then
    return { "biome_fix", "biome" }
  end

  if prettier_root(bufnr) then
    return { "prettier" }
  end

  return {}
end

require("conform").setup({
  formatters_by_ft = {
    javascript = formatters_for,
    typescript = formatters_for,
    javascriptreact = formatters_for,
    typescriptreact = formatters_for,
  },
  formatters = {
    biome = {
      command = "node_modules/.bin/biome",
      args = { "format", "--stdin-file-path", "$FILENAME" },
      stdin = true,
      cwd = biome_root,
      require_cwd = true,
    },
    biome_fix = {
      command = "node_modules/.bin/biome",
      args = { "check", "--write", "--stdin-file-path", "$FILENAME" },
      stdin = true,
      cwd = biome_root,
      require_cwd = true,
    },
    prettier = {
      command = "node_modules/.bin/prettier",
      args = { "--stdin-filepath", "$FILENAME" },
      stdin = true,
      cwd = prettier_root,
      require_cwd = true,
    },
  },
  format_on_save = {
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
    timeout_ms = 10000,
    lsp_fallback = false,
  }
})
