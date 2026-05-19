return {
  "rebelot/heirline.nvim",
  event = "UiEnter",
  config = function()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    -- Safe color getter: returns fallback if highlight group or field is nil
    local function hl_fg(name, fallback)
      local hl = utils.get_highlight(name)
      return hl and hl.fg or fallback
    end
    local function hl_bg(name, fallback)
      local hl = utils.get_highlight(name)
      return hl and hl.bg or fallback
    end

    local colors = {
      bright_bg = hl_bg("Folded", "#3b4261"),
      bright_fg = hl_fg("Folded", "#a9b1d6"),
      red = hl_fg("DiagnosticError", "#e06c75"),
      green = hl_fg("String", "#98c379"),
      blue = hl_fg("Function", "#61afef"),
      gray = hl_fg("NonText", "#5c6370"),
      orange = hl_fg("Constant", "#d19a66"),
      purple = hl_fg("Statement", "#c678dd"),
      cyan = hl_fg("Special", "#56b6c2"),
      yellow = hl_fg("DiagnosticWarn", "#e5c07b"),
      diag_warn = hl_fg("DiagnosticWarn", "#e5c07b"),
      diag_error = hl_fg("DiagnosticError", "#e06c75"),
      diag_hint = hl_fg("DiagnosticHint", "#56b6c2"),
      diag_info = hl_fg("DiagnosticInfo", "#61afef"),
      git_del = hl_fg("diffDeleted", nil) or hl_fg("DiffDelete", nil) or hl_fg("DiagnosticError", "#e06c75"),
      git_add = hl_fg("diffAdded", nil) or hl_fg("DiffAdd", nil) or hl_fg("String", "#98c379"),
      git_change = hl_fg("diffChanged", nil) or hl_fg("DiffChange", nil) or hl_fg("DiagnosticWarn", "#e5c07b"),
    }

    -- Helper: truncate branch names like "user/TEAM-1234-some-description" -> "user/TEAM-1234"
    local function truncate_branch(branch)
      if not branch or branch == "" then return "" end
      local user, team, ticket = branch:match("^(%w+)/(%w+)%-(%d+)")
      if ticket then
        return user .. "/" .. team .. "-" .. ticket
      end
      return branch
    end

    -- VCS info: fetched async, never blocks the UI
    local vcs_cache = { result = nil, cwd = nil, pending = false }

    local function fetch_vcs_info_async()
      local cwd = vim.fn.getcwd()
      if vcs_cache.pending then return end
      vcs_cache.pending = true

      -- Single jj command that gets both change_id and bookmarks in one shot
      vim.system(
        { "jj", "--ignore-working-copy", "log", "-r", "@", "--no-graph", "-T",
          "change_id.shortest(8) ++ \"\\n\" ++ bookmarks" },
        { cwd = cwd },
        vim.schedule_wrap(function(jj_out)
          vcs_cache.pending = false
          if jj_out.code == 0 and jj_out.stdout then
            local lines = vim.split(vim.trim(jj_out.stdout), "\n")
            local change_id = lines[1] or ""
            local bookmark = lines[2] or ""
            local first_bookmark = bookmark:match("^(%S+)")
            if first_bookmark and first_bookmark ~= "" then
              vcs_cache = {
                result = { vcs = "jj", branch = truncate_branch(first_bookmark), change_id = change_id, bookmark = first_bookmark },
                cwd = cwd, pending = false,
              }
            else
              vcs_cache = {
                result = { vcs = "jj", branch = change_id, change_id = change_id, bookmark = nil },
                cwd = cwd, pending = false,
              }
            end
            vim.cmd("redrawstatus")
            return
          end

          -- Fallback: git
          vim.system(
            { "git", "branch", "--show-current" },
            { cwd = cwd },
            vim.schedule_wrap(function(git_out)
              if git_out.code == 0 and git_out.stdout then
                local branch = vim.trim(git_out.stdout)
                if branch ~= "" then
                  vcs_cache = {
                    result = { vcs = "git", branch = truncate_branch(branch), change_id = nil, bookmark = nil },
                    cwd = cwd, pending = false,
                  }
                  vim.cmd("redrawstatus")
                  return
                end
              end
              vcs_cache = { result = nil, cwd = cwd, pending = false }
              vim.cmd("redrawstatus")
            end)
          )
        end)
      )
    end

    local function get_vcs_info()
      local cwd = vim.fn.getcwd()
      if vcs_cache.cwd ~= cwd then
        -- Cache miss: return stale/nil and fetch in background
        vcs_cache.cwd = cwd
        vcs_cache.result = nil
        fetch_vcs_info_async()
      end
      return vcs_cache.result
    end

    -- Refresh on directory change and periodically on focus/buffer changes
    vim.api.nvim_create_autocmd({ "DirChanged", "FocusGained" }, {
      callback = function()
        vcs_cache = { result = nil, cwd = nil, pending = false }
        fetch_vcs_info_async()
      end,
    })

    ---------------------------------------------------------------------------
    -- ViMode (with icons + labels like the old lualine)
    ---------------------------------------------------------------------------
    local ViMode = {
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      static = {
        mode_config = {
          n = { icon = "", label = "NORMAL", color = "blue" },
          no = { icon = "", label = "N-OP", color = "blue" },
          nov = { icon = "", label = "N-OP", color = "blue" },
          noV = { icon = "", label = "N-OP", color = "blue" },
          ["no\22"] = { icon = "", label = "N-OP", color = "blue" },
          niI = { icon = "", label = "NORMAL", color = "blue" },
          niR = { icon = "", label = "NORMAL", color = "blue" },
          niV = { icon = "", label = "NORMAL", color = "blue" },
          nt = { icon = "", label = "NORMAL", color = "blue" },
          v = { icon = " ", label = "VISUAL", color = "purple" },
          vs = { icon = " ", label = "VISUAL", color = "purple" },
          V = { icon = " ", label = "V-LINE", color = "purple" },
          Vs = { icon = " ", label = "V-LINE", color = "purple" },
          ["\22"] = { icon = " ", label = "V-BLOCK", color = "purple" },
          ["\22s"] = { icon = " ", label = "V-BLOCK", color = "purple" },
          s = { icon = "", label = "SELECT", color = "orange" },
          S = { icon = "", label = "S-LINE", color = "orange" },
          ["\19"] = { icon = "", label = "S-BLOCK", color = "orange" },
          i = { icon = "", label = "INSERT", color = "green" },
          ic = { icon = "", label = "INSERT", color = "green" },
          ix = { icon = "", label = "INSERT", color = "green" },
          R = { icon = "󰛔", label = "REPLACE", color = "red" },
          Rc = { icon = "󰛔", label = "REPLACE", color = "red" },
          Rx = { icon = "󰛔", label = "REPLACE", color = "red" },
          Rv = { icon = "󰛔", label = "REPLACE", color = "red" },
          Rvc = { icon = "󰛔", label = "REPLACE", color = "red" },
          Rvx = { icon = "󰛔", label = "REPLACE", color = "red" },
          c = { icon = " ", label = "COMMAND", color = "yellow" },
          cv = { icon = " ", label = "EX", color = "yellow" },
          r = { icon = "", label = "...", color = "cyan" },
          rm = { icon = "", label = "MORE", color = "cyan" },
          ["r?"] = { icon = "", label = "CONFIRM", color = "cyan" },
          ["!"] = { icon = "", label = "SHELL", color = "red" },
          t = { icon = " ", label = "TERMINAL", color = "cyan" },
        },
      },
      provider = function(self)
        local cfg = self.mode_config[self.mode] or { icon = "", label = self.mode, color = "gray" }
        return " " .. cfg.icon .. " " .. cfg.label .. " "
      end,
      hl = function(self)
        local cfg = self.mode_config[self.mode] or { color = "gray" }
        return { fg = cfg.color, bold = true }
      end,
      update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
          vim.cmd("redrawstatus")
        end),
      },
    }

    ---------------------------------------------------------------------------
    -- File info
    ---------------------------------------------------------------------------
    local FileIcon = {
      init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color =
          require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self)
        return self.icon and (self.icon .. " ")
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end,
    }

    local FileName = {
      provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then return "[No Name]" end
        if not conditions.width_percent_below(#filename, 0.25) then
          filename = vim.fn.pathshorten(filename)
        end
        return filename
      end,
      hl = { fg = utils.get_highlight("Directory").fg },
    }

    local FileFlags = {
      {
        condition = function() return vim.bo.modified end,
        provider = "  ",
        hl = { fg = "green" },
      },
      {
        condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
        provider = "  ",
        hl = { fg = "orange" },
      },
    }

    local FileNameBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
    }
    FileNameBlock = utils.insert(FileNameBlock, FileIcon, FileName, FileFlags, { provider = "%<" })

    ---------------------------------------------------------------------------
    -- VCS: Git / Jujutsu (cached, with diff stats from vcsigns)
    ---------------------------------------------------------------------------
    local VCS = {
      condition = function()
        return get_vcs_info() ~= nil
      end,
      init = function(self)
        self.vcs_info = get_vcs_info()
        self.stats = vim.b.vcsigns_stats or {}
      end,
      hl = { fg = "orange" },
      -- VCS icon
      {
        provider = function(self)
          if self.vcs_info.vcs == "jj" then return "󰜛 " end
          return " "
        end,
        hl = { bold = true },
      },
      -- Branch / change id
      {
        provider = function(self)
          return self.vcs_info.branch or ""
        end,
        hl = { bold = true },
      },
      -- Bookmark indicator (jj: when on a bookmark, show it separately from the change id)
      {
        condition = function(self)
          return self.vcs_info.vcs == "jj" and self.vcs_info.bookmark and self.vcs_info.change_id
            and self.vcs_info.branch ~= self.vcs_info.change_id
        end,
        provider = function(self)
          return " 󰃀 " .. self.vcs_info.change_id
        end,
        hl = { fg = "purple" },
      },
      -- Diff stats
      {
        provider = function(self)
          local count = self.stats.added or 0
          return count > 0 and (" +" .. count)
        end,
        hl = { fg = "git_add" },
      },
      {
        provider = function(self)
          local count = self.stats.removed or 0
          return count > 0 and (" -" .. count)
        end,
        hl = { fg = "git_del" },
      },
      {
        provider = function(self)
          local count = self.stats.modified or 0
          return count > 0 and (" ~" .. count)
        end,
        hl = { fg = "git_change" },
      },
    }

    ---------------------------------------------------------------------------
    -- Diagnostics
    ---------------------------------------------------------------------------
    local Diagnostics = {
      condition = conditions.has_diagnostics,
      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,
      update = { "DiagnosticChanged", "BufEnter" },
      {
        provider = function(self)
          return self.errors > 0 and (" " .. self.errors .. " ")
        end,
        hl = { fg = "diag_error" },
      },
      {
        provider = function(self)
          return self.warnings > 0 and (" " .. self.warnings .. " ")
        end,
        hl = { fg = "diag_warn" },
      },
      {
        provider = function(self)
          return self.info > 0 and (" " .. self.info .. " ")
        end,
        hl = { fg = "diag_info" },
      },
      {
        provider = function(self)
          return self.hints > 0 and (" " .. self.hints)
        end,
        hl = { fg = "diag_hint" },
      },
    }

    ---------------------------------------------------------------------------
    -- LSP (cogwheel + server names)
    ---------------------------------------------------------------------------
    local LSPActive = {
      condition = conditions.lsp_attached,
      update = { "LspAttach", "LspDetach" },
      { provider = " ", hl = { fg = "orange" } },
      {
        provider = function()
          local names = {}
          for _, server in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
            table.insert(names, server.name)
          end
          return table.concat(names, ", ")
        end,
        hl = { fg = "green", bold = true },
      },
    }

    ---------------------------------------------------------------------------
    -- Treesitter indicator
    ---------------------------------------------------------------------------
    local Treesitter = {
      condition = function()
        local b = vim.api.nvim_get_current_buf()
        return vim.treesitter.highlighter.active[b] ~= nil
      end,
      provider = "  ",
      hl = { fg = "green" },
    }

    ---------------------------------------------------------------------------
    -- Macro recording
    ---------------------------------------------------------------------------
    local MacroRec = {
      condition = function()
        return vim.fn.reg_recording() ~= ""
      end,
      provider = function()
        return " @" .. vim.fn.reg_recording()
      end,
      hl = { fg = "red", bold = true },
      update = { "RecordingEnter", "RecordingLeave" },
    }

    ---------------------------------------------------------------------------
    -- Search count
    ---------------------------------------------------------------------------
    local SearchCount = {
      condition = function()
        return vim.v.hlsearch == 1
      end,
      provider = function()
        local ok, result = pcall(vim.fn.searchcount, { recompute = 1, maxcount = -1 })
        if not ok or not result.current then return "" end
        if result.total > 0 then
          return " " .. result.current .. "/" .. result.total
        end
        return ""
      end,
      hl = { fg = "cyan" },
    }

    ---------------------------------------------------------------------------
    -- Ruler + ScrollBar
    ---------------------------------------------------------------------------
    local Ruler = {
      provider = "%7(%l/%3L%):%2c %P",
    }

    local ScrollBar = {
      static = {
        sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
      },
      provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
        return string.rep(self.sbar[i], 2)
      end,
      hl = { fg = "blue", bg = "bright_bg" },
    }

    ---------------------------------------------------------------------------
    -- FileType (icon from mini.icons, fallback to name)
    ---------------------------------------------------------------------------
    local FileType = {
      condition = function()
        return vim.bo.filetype ~= ""
      end,
      init = function(self)
        local ft = vim.bo.filetype
        local icons = require("mini.icons")
        local icon, hl, is_default = icons.get("filetype", ft)
        if icon and not is_default then
          self.ft_icon = icon
          self.ft_name = nil
          -- Resolve the highlight group color for the icon
          local ok, hl_def = pcall(vim.api.nvim_get_hl, 0, { name = hl, link = false })
          self.ft_color = (ok and hl_def.fg) and string.format("#%06x", hl_def.fg) or nil
        else
          self.ft_icon = nil
          self.ft_name = ft
          self.ft_color = nil
        end
      end,
      {
        provider = function(self)
          if self.ft_icon then return self.ft_icon .. " " end
          return self.ft_name or ""
        end,
        hl = function(self)
          if self.ft_color then
            return { fg = self.ft_color, bold = true }
          end
          return { fg = "cyan", bold = true }
        end,
      },
    }

    ---------------------------------------------------------------------------
    -- Assemble
    ---------------------------------------------------------------------------
    local Align = { provider = "%=" }
    local Space = { provider = " " }

    local StatusLine = {
      ViMode, Space,
      FileNameBlock, Space,
      VCS,
      Align,
      MacroRec, Space,
      SearchCount, Space,
      Diagnostics, Space,
      Treesitter,
      LSPActive, Space,
      FileType, Space,
      Ruler, Space,
      ScrollBar,
    }

    require("heirline").setup({
      statusline = StatusLine,
      opts = {
        colors = colors,
      },
    })

    -- Update colors on colorscheme change
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        utils.on_colorscheme(colors)
      end,
    })
  end,
}
