-- Override oxfmt root detection to also match vite-plus projects.
-- The base config comes from nvim-lspconfig (filetypes, cmd, etc.) and is
-- merged with this file automatically by Neovim's native lsp/ directory.

local util = require('lspconfig.util')

--- Check if the nearest package.json contains "vite-plus" as a dependency.
local function has_vite_plus(fname)
  local dir = vim.fn.fnamemodify(fname, ':h')
  local pkg = vim.fs.find('package.json', { path = dir, upward = true })[1]
  if not pkg then
    return false
  end

  local ok, contents = pcall(vim.fn.readfile, pkg)
  if not ok or vim.tbl_isempty(contents) then
    return false
  end

  local parse_ok, json = pcall(vim.json.decode, table.concat(contents, '\n'))
  if not parse_ok or type(json) ~= 'table' then
    return false
  end

  for _, key in ipairs({ 'dependencies', 'devDependencies', 'peerDependencies', 'optionalDependencies' }) do
    if type(json[key]) == 'table' and json[key]['vite-plus'] then
      return true
    end
  end

  return false
end

---@type vim.lsp.Config
return {
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)

    -- Primary: oxfmt config files or package.json mentioning "oxfmt"
    local root_markers = util.insert_package_json({ '.oxfmtrc.json', '.oxfmtrc.jsonc' }, 'oxfmt', fname)

    -- Fallback: vite-plus projects bundle oxfmt internally
    if has_vite_plus(fname) then
      table.insert(root_markers, 'package.json')
    end

    local found = vim.fs.find(root_markers, { path = fname, upward = true })[1]
    on_dir(found and vim.fs.dirname(found) or nil)
  end,
}
