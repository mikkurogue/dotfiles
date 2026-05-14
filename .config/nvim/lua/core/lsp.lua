local v = vim

-- LSP configurations

local function on_lsp_exit(code, signal, client_id)
  local client = v.lsp.get_client_by_id(client_id)
  if not client then return end

  -- Don't show message on normal exit
  if code == 0 and signal == 0 then
    return
  end

  v.notify(
    string.format("LSP client '%s' crashed. (code: %s, signal: %s)", client.name, tostring(code), tostring(signal)),
    v.log.levels.WARN
  )

  v.notify(string.format("Attempting to restart LSP client: %s", client.name), v.log.levels.INFO)

  local new_client_id = v.lsp.start_client(client.config)
  if new_client_id then
    v.notify(string.format("LSP client '%s' has been restored.", client.name), v.log.levels.INFO)
    -- Re-attach to the current buffer
    v.lsp.buf_attach_client(0, new_client_id)
  else
    v.notify(string.format("Failed to restart LSP client: %s", client.name), v.log.levels.ERROR)
  end
end

-- Shared config for all LSP servers
-- Note: capabilities are already set by blink.cmp's plugin file via vim.lsp.config('*')
v.lsp.config('*', {
  on_exit = on_lsp_exit,
})

local vue_ls_path = v.uv.fs_realpath(v.fn.exepath('vue-language-server')) or v.fn.exepath('vue-language-server')

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = v.fn.fnamemodify(vue_ls_path, ':p:h:h'),
  languages = { 'vue' },
  configNamespace = 'typescript',
}

local effect_plugin = {
  name = '@effect/language-service',
  languages = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  enableForWorkspaceTypeScriptVersions = true,
}

v.lsp.config('vtsls', {
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
      tsserver = {
        globalPlugins = {
          vue_plugin,
          effect_plugin,
        },
      },
    },
  },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
})

local lsps = {
  'rust_analyzer',
  'gopls',
  'vtsls',
  'lua_ls',
  'biome',
  'zls',
  'tailwindcss',
  'svelte',
  'oxfmt',
  'oxlint',
  'vue_ls',
  'bash-language-server',
  'emmet_language_server'
}

v.lsp.enable(lsps)

-- show lsp that is attached to buffer
function _G.LspStatus()
  local bufnr = v.api.nvim_get_current_buf()
  local clients = v.lsp.get_clients({ bufnr = bufnr })
  if #clients == 0 then
    return ''
  end

  local icons = {
    rust_analyzer = '󱘗',
    go = '󰟓',
    vtsls = '',
    ts_ls = '',
    lua_ls = '󰢱',
    biome = '󰐅',
    zls = '',
    tailwindcss = '󱏿',
    svelte = '',
  }

  local names = {}
  for _, c in ipairs(clients) do
    local icon = icons[c.name] or ''
    table.insert(names, icon .. ' ' .. c.name)
  end
  return table.concat(names, ', ')
end
