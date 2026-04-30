local util = require("conform.util")
local oxfmt_root_files = { ".oxfmtrc.json", ".oxfmtrc.jsonc" }
local oxlint_root_files = {
  "oxlintrc.json",
  ".oxlintrc.json",
  ".oxlintrc",
}

local oxfmt_root = util.root_file({ ".oxfmtrc.json", ".oxfmtrc.jsonc", "package.json" })

local function has_root_file(bufnr, files)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local dirname = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()
  return vim.fs.root(dirname, files) ~= nil
end

local function read_package_json(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local dirname = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()
  local package_file = vim.fs.find("package.json", { path = dirname, upward = true })[1]
  if not package_file then
    return nil
  end

  local lines = vim.fn.readfile(package_file)
  if vim.tbl_isempty(lines) then
    return nil
  end

  local ok, package = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not ok or type(package) ~= "table" then
    return nil
  end

  return package
end


local function has_oxc_package(bufnr)
  local package = read_package_json(bufnr)
  if not package then
    return false
  end

  local dependency_keys = {
    "dependencies",
    "devDependencies",
    "peerDependencies",
    "optionalDependencies",
  }

  for _, key in ipairs(dependency_keys) do
    local deps = package[key]
    if type(deps) == "table" and (deps.oxfmt or deps.oxlint) then
      return true
    end
  end

  local scripts = package.scripts
  if type(scripts) == "table" then
    for _, value in pairs(scripts) do
      if type(value) == "string" and (value:find("oxfmt", 1, true) or value:find("oxlint", 1, true)) then
        return true
      end
    end
  end

  return false
end

local function formatters_for(bufnr)
  local conform = require("conform")

  if has_root_file(bufnr, oxfmt_root_files) or has_root_file(bufnr, oxlint_root_files) or has_oxc_package(bufnr) then
    local formatters = {}
    if conform.get_formatter_info("oxfmt", bufnr).available then
        table.insert(formatters, "oxfmt")
      end
    if not vim.tbl_isempty(formatters) then
      return formatters
    end
  end


  return {}
end

require("conform").setup({
  formatters_by_ft = {
    javascript = formatters_for,
    typescript = formatters_for,
    javascriptreact = formatters_for,
    typescriptreact = formatters_for,
    json = formatters_for,
    vue = formatters_for,
    yaml = formatters_for,
    yml = formatters_for,
    rust = { lsp_format = "prefer" },
  },
  formatters = {
    oxfmt = {
      command = "oxfmt",
      args = { "--stdin-filepath", "$FILENAME" },
      stdin = true,
      cwd = oxfmt_root,
      require_cwd = true,
    },
  },
  format_on_save = {
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.vue", "*.yml", "*.yaml", "*.rs" },
    timeout_ms = 10000,
    lsp_fallback = false,
  }
})
