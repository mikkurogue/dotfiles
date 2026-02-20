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
      vcs_cache = { result = " " .. change_id, cwd = cwd, vcs_type = "jj" }
    else
      local first = bookmark:match("^(%S+)") or bookmark
      vcs_cache = { result = " " .. truncate_branch_name(first), cwd = cwd, vcs_type = "jj" }
    end
    return vcs_cache.result
  end

  -- Fallback: git branch
  local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("%s+$", "")
  if vim.v.shell_error == 0 and branch ~= "" then
    vcs_cache = { result = " " .. truncate_branch_name(branch), cwd = cwd, vcs_type = "git" }
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

-- Macro recording indicator
local function get_macro_recording()
  local reg = vim.fn.reg_recording()
  if reg ~= '' then
    return ' @' .. reg
  end
  return ''
end

-- Search count
local function get_search_count()
  if vim.v.hlsearch == 0 then return '' end
  local ok, result = pcall(vim.fn.searchcount, { recompute = 1, maxcount = -1 })
  if not ok or result.current == nil then return '' end
  if result.total > 0 then
    return ' ' .. result.current .. '/' .. result.total
  end
  return ''
end

-- Treesitter status
local function get_treesitter_status()
  local b = vim.api.nvim_get_current_buf()
  if vim.treesitter.highlighter.active[b] then
    return ' '
  end
  return ''
end

-- Scrollbar indicator using cool Unicode blocks
local function get_scrollbar()
  local chars = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
  local line = vim.fn.line('.')
  local total = vim.fn.line('$')
  local idx = math.ceil(line / total * #chars)
  return chars[idx] or chars[1]
end

-- Enhanced cursor position - cleaner format
local function get_cursor_position()
  local line = vim.fn.line('.')
  local col = vim.fn.col('.')
  local total = vim.fn.line('$')
  local percent = math.floor((line / total) * 100)
  return string.format('%d:%d %s %d%%%%', line, col, get_scrollbar(), percent)
end

-- Mode config with labels and dynamic colors
local mode_config = {
  ['n']     = { icon = '', label = 'NORMAL', color = { bg = '#61afef', fg = '#282c34', gui = 'bold' } },
  ['i']     = { icon = '', label = 'INSERT', color = { bg = '#98c379', fg = '#282c34', gui = 'bold' } },
  ['v']     = { icon = ' ', label = 'VISUAL', color = { bg = '#c678dd', fg = '#282c34', gui = 'bold' } },
  ['V']     = { icon = ' ', label = 'V-LINE', color = { bg = '#c678dd', fg = '#282c34', gui = 'bold' } },
  ['\22']   = { icon = ' ', label = 'V-BLOCK', color = { bg = '#c678dd', fg = '#282c34', gui = 'bold' } },
  ['c']     = { icon = ' ', label = 'COMMAND', color = { bg = '#e5c07b', fg = '#282c34', gui = 'bold' } },
  ['t']     = { icon = ' ', label = 'TERMINAL', color = { bg = '#56b6c2', fg = '#282c34', gui = 'bold' } },
  ['R']     = { icon = '󰛔', label = 'REPLACE', color = { bg = '#e06c75', fg = '#282c34', gui = 'bold' } },
  ['s']     = { icon = '', label = 'SELECT', color = { bg = '#d19a66', fg = '#282c34', gui = 'bold' } },
  ['S']     = { icon = '', label = 'S-LINE', color = { bg = '#d19a66', fg = '#282c34', gui = 'bold' } },
  ['\19']   = { icon = '', label = 'S-BLOCK', color = { bg = '#d19a66', fg = '#282c34', gui = 'bold' } },
}

local function get_mode_icon()
  local mode = vim.fn.mode()
  local cfg = mode_config[mode] or { icon = '', label = mode, color = { bg = '#5c6370', fg = '#282c34', gui = 'bold' } }
  return cfg.icon .. ' ' .. cfg.label
end

local function get_mode_color()
  local mode = vim.fn.mode()
  local cfg = mode_config[mode] or { color = { bg = '#5c6370', fg = '#282c34', gui = 'bold' } }
  return cfg.color
end

-- Pill separators (rounded) for powerline look
local pill_left = '' 
local pill_right = ''

-- Colors for OneDark theme
local colors = {
  bg = '#282c34',
  bg_dark = '#21252b',
  bg_light = '#2c323c',
  fg = '#abb2bf',
  red = '#e06c75',
  green = '#98c379',
  yellow = '#e5c07b',
  blue = '#61afef',
  purple = '#c678dd',
  cyan = '#56b6c2',
  orange = '#d19a66',
  gray = '#5c6370',
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    -- Rounded pill separators for that cool powerline look
    component_separators = '',
    section_separators = { left = pill_right, right = pill_left },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    -- Section A: Mode pill (dynamic color based on mode)
    lualine_a = {
      {
        get_mode_icon,
        color = get_mode_color,
        separator = { left = '', right = pill_right },
        padding = { left = 1, right = 1 },
      }
    },

    -- Section B: VCS branch in a pill
    lualine_b = {
      {
        get_vcs_info,
        icon = '',
        color = { bg = colors.bg_light, fg = colors.fg, gui = 'bold' },
        separator = { left = pill_left, right = pill_right },
        padding = { left = 1, right = 1 },
      },
    },

    -- Section C: Diff + Diagnostics + Filename (floating style)
    lualine_c = {
      {
        'diff',
        symbols = {
          added = '+',
          modified = '~',
          removed = '-',
        },
        diff_color = {
          added = { fg = colors.green },
          modified = { fg = colors.yellow },
          removed = { fg = colors.red },
        },
        source = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local summary = vim.b[bufnr].vcsigns_summary
          if summary then
            return {
              added = summary.added or 0,
              modified = summary.modified or 0,
              removed = summary.removed or 0,
            }
          end
          return nil
        end,
        padding = { left = 1, right = 0 },
      },
      {
        'diagnostics',
        symbols = {
          error = ' ',
          warn = ' ',
          info = ' ',
          hint = ' ',
        },
        diagnostics_color = {
          error = { fg = colors.red },
          warn = { fg = colors.yellow },
          info = { fg = colors.blue },
          hint = { fg = colors.cyan },
        },
        padding = { left = 1, right = 1 },
      },
      {
        'filename',
        path = 0,  -- Relative path
        symbols = {
          modified = ' ',
          readonly = ' ',
          unnamed = '[No Name]',
          newfile = '[New]',
        },
        color = { fg = colors.fg, gui = 'italic' },
        file_status = true,
        padding = { left = 2, right = 1 },
      },
    },

    -- Section X: LSP, Treesitter, Search, Macro
    lualine_x = {
      {
        get_macro_recording,
        color = { fg = colors.red, gui = 'bold' },
        cond = function()
          return vim.fn.reg_recording() ~= ''
        end,
        padding = { left = 1, right = 1 },
      },
      {
        get_search_count,
        color = { fg = colors.cyan },
        cond = function()
          return vim.v.hlsearch == 1
        end,
        padding = { left = 1, right = 1 },
      },
      {
        get_treesitter_status,
        color = { fg = colors.green, bg = colors.bg_dark },
        cond = function()
          local b = vim.api.nvim_get_current_buf()
          return vim.treesitter.highlighter.active[b] ~= nil
        end,
        separator = { left = pill_left, right = '' },
        padding = { left = 1, right = 1 },
      },
      {
        function()
          return _G.LspStatus and _G.LspStatus() or ''
        end,
        icon = ' ',
        color = { fg = colors.blue, bg = colors.gray },
        separator = { left = pill_left, right = '' },
        cond = function()
          return _G.LspStatus and _G.LspStatus() ~= ''
        end,
        padding = { left = 1, right = 1 },
      },
    },

    -- Section Y: Filetype pill
    lualine_y = {
      {
        'filetype',
        colored = true,
        icon_only = false,
        icon = { align = 'left' },
        color = { bg = colors.bg_light, fg = colors.fg },
        separator = { left = pill_left, right = '' },
        padding = { left = 1, right = 1 },
      },
    },

    -- Section Z: Position pill with scrollbar
    lualine_z = {
      {
        get_cursor_position,
        color = { bg = colors.blue, fg = colors.bg, gui = 'bold' },
        separator = { left = pill_left, right = '' },
        padding = { left = 1, right = 1 },
      }
    }
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        path = 1,
        symbols = {
          modified = ' ',
          readonly = ' ',
        },
        color = { fg = colors.gray },
      }
    },
    lualine_x = {
      {
        'location',
        color = { fg = colors.gray },
      }
    },
    lualine_y = {},
    lualine_z = {}
  },

  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = { 'quickfix', 'fugitive', 'nvim-dap-ui', 'oil' }
}
