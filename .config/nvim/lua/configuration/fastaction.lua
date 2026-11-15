return {
  'Chaitanyabsprip/fastaction.nvim',
  ---@type FastActionConfig
  opts = {
    -- fastaction owns vim.ui.select permanently. Combined with the wrapper
    -- below, LSP code actions go straight through vim.lsp.buf.code_action()
    -- with no temporary swapping at all.
    register_ui_select = true,
    -- Home-row first; kept explicit so it survives upstream default changes.
    keys = 'fjdkslaghrueiwocnxvbmztyqp',
    dismiss_keys = { 'j', 'k', '<c-c>', 'q', '<esc>' },
    -- Stable mnemonic keys per pattern. Matched case-insensitively against
    -- the action title; keyed by filetype OR LSP client name (both work,
    -- client names are used here since patterns are server-specific).
    priority = {
      default = {
        { pattern = 'organize import', key = 'o', order = 1 },
        { pattern = 'quickfix', key = 'f', order = 2 },
      },
      vtsls = {
        { pattern = 'to existing import declaration', key = 'a', order = 1 },
        { pattern = 'add missing import', key = 'a', order = 2 },
        { pattern = 'extract', key = 'e', order = 3 },
        { pattern = 'move to', key = 'm', order = 4 },
        { pattern = 'inline', key = 'i', order = 5 },
      },
      tsc = {
        { pattern = 'to existing import declaration', key = 'a', order = 1 },
        { pattern = 'add missing import', key = 'a', order = 2 },
        { pattern = 'extract', key = 'e', order = 3 },
      },
      rust_analyzer = {
        { pattern = 'extract', key = 'e', order = 1 },
        { pattern = 'fill match arms', key = 'm', order = 2 },
        { pattern = 'implement', key = 'i', order = 3 },
        { pattern = 'generate', key = 'g', order = 4 },
        { pattern = 'import', key = 'a', order = 5 },
        { pattern = 'inline', key = 'v', order = 6 },
        { pattern = 'move to', key = 'm', order = 7 },
      },
      gopls = {
        { pattern = 'fill', key = 'f', order = 1 },
        { pattern = 'extract', key = 'e', order = 2 },
        { pattern = 'inline', key = 'v', order = 3 },
        { pattern = 'generate', key = 'g', order = 4 },
        { pattern = 'import', key = 'a', order = 5 },
      },
      lua_ls = {
        { pattern = 'export', key = 'e', order = 1 },
        { pattern = 'docstring', key = 'd', order = 2 },
      },
      biome = {
        { pattern = 'organize import', key = 'o', order = 0 },
        { pattern = 'fix', key = 'f', order = 1 },
      },
      oxlint = {
        { pattern = 'fix', key = 'f', order = 1 },
      },
    },
  },
  config = function(_, opts)
    local fastaction = require('fastaction')
    fastaction.setup(opts)

    -- Upstream code_action() temporarily swaps vim.ui.select and only
    -- restores it from a WinLeave autocmd on its popup. If no actions come
    -- back the popup never opens, so the swap leaks into the rest of the
    -- session - and once priorities are configured, sort_items then crashes
    -- on every non-LSP picker because it unconditionally indexes
    -- item.action.title.
    --
    -- Avoid the swap entirely: vim.ui.select is already fastaction's select
    -- (register_ui_select), so teach it to sort and cursor-anchor code actions
    -- by their `kind`, and trigger code actions via vim.lsp.buf.code_action().
    --
    -- setup() installs the raw select into vim.ui.select, so the wrapper is
    -- (re)installed explicitly afterwards.
    local select = fastaction.select
    fastaction.select = function(items, select_opts, on_choice)
      if select_opts and select_opts.kind == 'codeaction' then
        select_opts = vim.tbl_extend('force', select_opts, { relative = 'cursor' })
        items = fastaction.sort_items(items)
      end
      return select(items, select_opts, on_choice)
    end
    vim.ui.select = fastaction.select
  end,
}
