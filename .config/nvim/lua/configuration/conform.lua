local util = require("conform.util")
local biome_root_files = { "biome.json", "biome.jsonc" }
local prettier_root_files = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.json5",
  ".prettierrc.yml",
  ".prettierrc.yaml",
  ".prettierrc.js",
  ".prettierrc.cjs",
  "prettier.config.js",
  "prettier.config.cjs",
}

local biome_root = util.root_file(biome_root_files)
local prettier_root = util.root_file(prettier_root_files)

local function has_root_file(bufnr, files)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local dirname = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()
  return vim.fs.root(dirname, files) ~= nil
end

local function formatters_for(bufnr)
  if has_root_file(bufnr, biome_root_files) then
    return { "biome_fix", "biome" }
  end

  if has_root_file(bufnr, prettier_root_files) then
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
