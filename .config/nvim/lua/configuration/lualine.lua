-- Statusline: lualine with a powerline feel, glyph-rich and crate-powered.
--
-- Colour inheritance: `options.theme = "auto"` resolves `vim.g.colors_name`
-- against a matching `lualine/themes/<name>.lua` on the runtimepath --
-- kanagawa.nvim ships one. Colorschemes without one fall back to a theme
-- lualine generates from the live highlight groups. Anything we color
-- ourselves uses fg-only color tables/functions: lualine then fills in the
-- background from the theme (mode-aware), so `:colorscheme anything` keeps
-- every block on a matching background.
--
-- Glyph hygiene: Nerd Font glyphs in the 3-byte private-use area (U+E000-)
-- are built via nr2char() below -- literal PUA glyphs in dotfiles tend to get
-- mangled by shell pipes, formatters and git tooling; codepoints don't. All
-- codepoints are verified against the Nerd Fonts catalog.

return {
  "nvim-lualine/lualine.nvim",
  event = "UIEnter",
  dependencies = { "nvim-mini/mini.icons" },
  config = function()
    local function nf(cp)
      return vim.fn.nr2char(tonumber(cp, 16))
    end

    local glyphs = {
      branch = nf("f126"), -- [git] fa-code-branch
      diff_add = nf("eadc"), -- cod-diff-added
      diff_mod = nf("eade"), -- cod-diff-modified
      diff_del = nf("eadf"), -- cod-diff-removed
      diag_error = nf("f52f"), -- [x] oct-x-circle
      diag_warn = nf("f0026"), -- 󰀦 md-alert
      diag_info = nf("f449"), --  oct-info
      diag_hint = nf("ea61"), --  cod-lightbulb
      record = nf("f044a"), -- 󰑊 md-record
      treesitter = nf("f0e66"), -- 󰹦 md-sprout (file "growing" under TS)
      lsp = nf("f0ad"), --  fa-wrench
      rust_server = nf("f1617"), -- 󱘗 md-language-rust (the Rust gear)
      lock = nf("f023"), --  fa-lock
      search = nf("f002"), --  fa-search
    }

    -- live, colorscheme-consuming fg color (evaluated on every redraw)
    local function fg_of(group, fallback)
      return function()
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        if ok and hl and hl.fg then
          return { fg = string.format("#%06x", hl.fg) }
        end
        return { fg = fallback }
      end
    end

    ---------------------------------------------------------------------------
    -- File info: lualine's filetype (icon) + filename components.
    -- The devicons mock serves our glyphs (incl. the Rust gear); the
    -- colored icon is derived from a fg-only table, so its background stays
    -- the theme's section color (fg-only is the contract: lualine fills the
    -- bg itself, mode-aware -- string colors like color = "String" bypass
    -- that and render with no background at all).
    ---------------------------------------------------------------------------
    local normal_buffer = function()
      return vim.bo.buftype == ""
    end

    local FileTypeIcon = {
      "filetype",
      icon_only = true,
      colored = true,
      padding = { left = 0, right = 0 },
      cond = normal_buffer,
    }

    local FileName = {
      "filename",
      path = 1, -- cwd-relative; lualine shortens against the window width
      file_status = false, -- flags are their own components, so they get colors
      symbols = { modified = "", readonly = "", unnamed = "[No Name]" },
      padding = { left = 0, right = 0 },
      cond = normal_buffer,
    }

    local FileModified = {
      cond = function()
        return vim.bo.modified
      end,
      function()
        return " ●" -- plain U+25CF: renders in every font that matters
      end,
      color = fg_of("String", "#98c379"),
      padding = { left = 0, right = 0 },
    }

    local FileReadonly = {
      cond = function()
        return vim.bo.readonly or not vim.bo.modifiable
      end,
      function()
        return " " .. glyphs.lock
      end,
      color = fg_of("DiagnosticWarn", "#e5c07b"),
      padding = { left = 0, right = 0 },
    }

    ---------------------------------------------------------------------------
    -- Diagnostics (built-in: colors follow Diagnostic* groups of the theme)
    ---------------------------------------------------------------------------
    local Diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warn", "info", "hint" },
      symbols = {
        error = glyphs.diag_error,
        warn = glyphs.diag_warn,
        info = glyphs.diag_info,
        hint = glyphs.diag_hint,
      },
      colored = true,
      update_in_insert = false,
      always_visible = false,
    }

    ---------------------------------------------------------------------------
    -- Treesitter indicator (sprout while the buffer is TS-highlighted)
    ---------------------------------------------------------------------------
    local TreeSprout = {
      function()
        return glyphs.treesitter
      end,
      cond = function()
        return vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil
      end,
      color = fg_of("String", "#98c379"),
    }

    ---------------------------------------------------------------------------
    -- LSP: one block per attached client -- glyph + name + live status.
    -- Extends lualine's `lsp_status`, so it works generically: `$/progress`
    -- reporters (rust-analyzer, gopls, clangd, ...) get a spinner while busy
    -- and a check when settled; others just show name.
    ---------------------------------------------------------------------------
    -- Per-server glyphs, ported from the old _G.LspStatus() (once in
    -- core/lsp.lua). Unknown servers fall back to the wrench.
    local server_glyphs = {
      rust_analyzer = glyphs.rust_server,
      go = nf("f07d3"), -- 󰟓 md-language-go
      clangd = nf("e7a3"), --  dev-cplusplus
      tsc = nf("e8ca"), --  dev-typescript
      vtsls = nf("e8ca"),
      ts_ls = nf("e8ca"),
      lua_ls = nf("f08b1"), -- 󰢱 md-language-lua
      biome = nf("f0405"), -- 󰐅 md-pine-tree
      zls = nf("e8ef"), --  dev-zig
      tailwindcss = nf("f13ff"), -- 󱏿 md-tailwind
      svelte = nf("e8b7"), --  dev-svelte
    }
    -- Names that render better in the bar
    local server_names = {
      rust_analyzer = "rust-analyzer",
      emmet_language_server = "emmet",
      ["bash-language-server"] = "bashls",
    }

    local LspStatus = require("lualine.components.lsp_status"):extend()

    function LspStatus:update_status()
      local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
      if #clients == 0 then
        return ""
      end
      -- Same 80ms spinner cadence as the parent component (see lsp_status.lua)
      local hrtime = (vim.uv or vim.loop).hrtime
      local spinner = self.symbols.spinner[math.floor(hrtime() / (1e6 * 80)) % #self.symbols.spinner + 1]
      local state -- "" | spinner | done
      local parts = {}
      for _, client in ipairs(clients) do
        if not vim.list_contains(self.options.ignore_lsp, client.name) then
          local work = self.lsp_work_by_client_id[client.id] -- maintained by the parent's LspProgress autocmd
          state = (work and work > 0 and " " .. spinner)
            or (work ~= nil and " " .. self.symbols.done)
            or ""
          local glyph = server_glyphs[client.name] or glyphs.lsp
          local name = (self.options.show_name ~= false)
            and (" " .. (server_names[client.name] or client.name))
            or ""
          parts[#parts + 1] = glyph .. name .. state
        end
      end
      return table.concat(parts, ", ")
    end

    ---------------------------------------------------------------------------
    -- Search count while hlsearch is active
    ---------------------------------------------------------------------------
    local SearchCount = {
      "searchcount",
      maxcount = 999,
      timeout = 500,
      icon = glyphs.search,
    }

    ---------------------------------------------------------------------------
    -- Macro recording notice (loud, red, transient)
    ---------------------------------------------------------------------------
    local MacroRec = {
      cond = function()
        return vim.fn.reg_recording() ~= ""
      end,
      function()
        return glyphs.record .. " @" .. vim.fn.reg_recording()
      end,
      color = fg_of("DiagnosticError", "#e06c75"),
      padding = { left = 0, right = 1 },
    }

    local function lualine_config()
      require("lualine").setup({
        options = {
          -- powerline look: hard section separators ( and ) and soft
          -- component separators ( and ) are lualine's own defaults
          theme = "auto",
          globalstatus = true, -- matches `laststatus = 3` in core/opts.lua
          -- keep the rust-analyzer spinner spinning even when idle
          refresh = { statusline = 200 },
        },
        sections = {
          lualine_a = { "mode", MacroRec },
          lualine_b = {
            { "branch", icon = glyphs.branch },
            {
              "diff",
              colored = true,
              symbols = {
                added = glyphs.diff_add,
                modified = glyphs.diff_mod,
                removed = glyphs.diff_del,
              },
            },
            { "selectioncount" }, -- only shows while selecting
          },
          lualine_c = { FileTypeIcon, FileName, FileModified, FileReadonly, Diagnostics },
          lualine_x = { TreeSprout, { LspStatus, color = fg_of("Special", "#61afef") }, SearchCount },
          lualine_y = { "fileformat", "encoding" },
          lualine_z = { "progress", "location" },
        },
        extensions = { "oil", "trouble", "quickfix" },
      })
    end

    lualine_config()

    -- Macro start/stop can happen between lualine's own refresh timers.
    vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
      group = vim.api.nvim_create_augroup("lualine_macro_refresh", { clear = true }),
      callback = function()
        vim.schedule(function()
          require("lualine").refresh()
        end)
      end,
    })
  end,
}
