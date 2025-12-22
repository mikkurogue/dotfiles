local function truncate_branch_name(branch)
  if not branch or branch == "" then
    return ""
  end

  local user, team, ticket_number = string.match(branch, "^(%w+)/(%w+)%-(%d+)")

  if ticket_number then
    return user .. "/" .. team .. "-" .. ticket_number
  else
    return branch
  end
end

local vcs_cache = { result = nil, cwd = nil, vcs_type = nil }

local function get_vcs_info()
  local cwd = vim.fn.getcwd()
  if vcs_cache.cwd == cwd and vcs_cache.result then
    return vcs_cache.result
  end

  -- Check jj first (priority over git for colocated repos)
  vim.fn.system("jj root 2>/dev/null")
  if vim.v.shell_error == 0 then
    local bookmark = vim.fn.system("jj log -r @ --no-graph -T 'bookmarks'"):gsub("%s+$", "")
    if bookmark == "" then
      local change_id = vim.fn.system("jj log -r @ --no-graph -T 'change_id.shortest(8)'"):gsub("%s+$", "")
      vcs_cache = { result = "󱗆 " .. change_id, cwd = cwd, vcs_type = "jj" }
    else
      local first = bookmark:match("^(%S+)") or bookmark
      vcs_cache = { result = "󱗆 " .. truncate_branch_name(first), cwd = cwd, vcs_type = "jj" }
    end
    return vcs_cache.result
  end

  -- Fallback: git branch
  local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("%s+$", "")
  if vim.v.shell_error == 0 and branch ~= "" then
    vcs_cache = { result = " " .. truncate_branch_name(branch), cwd = cwd, vcs_type = "git" }
    return vcs_cache.result
  end

  vcs_cache = { result = "", cwd = cwd, vcs_type = nil }
  return ""
end

vim.api.nvim_create_autocmd({ "DirChanged", "BufEnter", "FocusGained" }, {
  callback = function()
    vcs_cache = { result = nil, cwd = nil, vcs_type = nil }
  end,
})

local function get_vcs_name()
  get_vcs_info() -- Ensure cache is populated
  return vcs_cache.vcs_type or ""
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { get_vcs_info, 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { get_vcs_name, 'fileformat', 'filetype' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
