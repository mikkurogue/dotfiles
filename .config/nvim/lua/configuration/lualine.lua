-- ============================================================================
-- VCS Functions (Preserve existing functionality)
-- ============================================================================

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

-- ============================================================================
-- New Utility Functions
-- ============================================================================

-- Macro recording indicator
local function get_macro_recording()
  local reg = vim.fn.reg_recording()
  if reg ~= '' then
    return '⏺ @' .. reg
  end
  return ''
end

-- Search count
local function get_search_count()
  if vim.v.hlsearch == 0 then return '' end
  local ok, result = pcall(vim.fn.searchcount, { recompute = 1, maxcount = -1 })
  if not ok or result.current == nil then return '' end
  if result.total > 0 then
    return string.format(' %d/%d', result.current, result.total)
  end
  return ''
end

-- Treesitter status
local function get_treesitter_status()
  local b = vim.api.nvim_get_current_buf()
  if vim.treesitter.highlighter.active[b] then
    return ''
  end
  return ''
end

-- Enhanced cursor position with visual percentage bar
local function get_cursor_position()
  local line = vim.fn.line('.')
  local col = vim.fn.col('.')
  local total = vim.fn.line('$')
  local percent = math.floor((line / total) * 100)
  
  -- Create a visual percentage bar
  local bar_width = 8
  local filled = math.floor((percent / 100) * bar_width)
  local bar = string.rep('━', filled) .. string.rep('─', bar_width - filled)
  
  return string.format(' %d:%d  %s %d%%%%  %d', line, col, bar, percent, total)
end

-- Mode with icons
local function get_mode_with_icon()
  local mode = vim.fn.mode()
  local mode_map = {
    ['n'] = ' NORMAL',
    ['i'] = ' INSERT',
    ['v'] = '󰈈 VISUAL',
    ['V'] = '󰈈 V-LINE',
    ['\22'] = '󰩬 V-BLOCK',  -- Ctrl-V
    ['c'] = ' COMMAND',
    ['t'] = ' TERMINAL',
    ['R'] = '󰛔 REPLACE',
    ['s'] = ' SELECT',
    ['S'] = ' S-LINE',
    ['\19'] = ' S-BLOCK',  -- Ctrl-S
  }
  return mode_map[mode] or '󰻀 ' .. mode
end

-- ============================================================================
-- Lualine Setup with Enhanced Icons and Components
-- ============================================================================

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    -- Powerline separators
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,  -- Match your laststatus = 3 setting
    -- Faster refresh rate for more responsive updates
    refresh = {
      statusline = 500,
      tabline = 500,
      winbar = 500,
    }
  },
  sections = {
    -- Section A: Mode with icons
    lualine_a = {
      {
        get_mode_with_icon,
        separator = { right = '' },
        padding = { left = 1, right = 1 }
      }
    },
    
    -- Section B: VCS info, diff, and diagnostics
    lualine_b = {
      {
        get_vcs_info,
        icon = '',
        separator = { right = '' },
      },
      {
        'diff',
        symbols = {
          added = ' ',
          modified = ' ',
          removed = ' '
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
        separator = { right = '' },
      },
      {
        'diagnostics',
        symbols = {
          error = ' ',
          warn = ' ',
          info = ' ',
          hint = '󰌵 '
        },
        separator = { right = '' },
      }
    },
    
    -- Section C: Filename with enhanced symbols
    lualine_c = {
      {
        'filename',
        path = 0, -- Just filename, no path
        symbols = {
          modified = ' ',
          readonly = ' ',
          unnamed = '󰡯 ',
          newfile = ' '
        },
        file_status = true,
        separator = { right = '' },
      }
    },
    
    -- Section X: Cool extra components
    lualine_x = {
      {
        get_macro_recording,
        color = { fg = '#e06c75', gui = 'bold' },
        separator = { left = '' },
      },
      {
        get_search_count,
        color = { fg = '#61afef' },
        separator = { left = '' },
      },
      {
        get_treesitter_status,
        color = { fg = '#98c379' },
        separator = { left = '' },
      },
      {
        function()
          return _G.LspStatus()
        end,
        icon = '',
        color = { gui = 'bold' },
        separator = { left = '' },
      },
    },
    
    -- Section Y: File info and VCS type
    lualine_y = {
      {
        'encoding',
        fmt = function(str)
          if str == 'utf-8' then
            return ' ' .. str:upper()
          else
            return ' ' .. str:upper()
          end
        end,
        cond = function()
          return vim.bo.fileencoding ~= 'utf-8'
        end,
        separator = { left = '' },
      },
      {
        'fileformat',
        icons_enabled = true,
        symbols = {
          unix = ' ',
          dos = ' ',
          mac = ' '
        },
        separator = { left = '' },
      },
      {
        'filetype',
        colored = true,
        icon_only = false,
        icon = { align = 'right' },
        separator = { left = '' },
      },
      {
        get_vcs_name,
        icon = '󰊢',
        cond = function()
          return get_vcs_name() ~= ''
        end,
        separator = { left = '' },
      }
    },
    
    -- Section Z: Enhanced cursor position with percentage bar
    lualine_z = {
      {
        get_cursor_position,
        separator = { left = '' },
        padding = { left = 1, right = 1 }
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
          modified = ' ',
          readonly = ' ',
        }
      }
    },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
