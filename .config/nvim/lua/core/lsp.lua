local v = vim

-- LSP configurations
local capabilities = require("blink.cmp").get_lsp_capabilities(v.lsp.protocol.make_client_capabilities())

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

local lsps = {
  'rust_analyzer',
  'gopls',
  'vtsls',
  'lua_ls',
  'biome',
  'zls',
  'ocamllsp'
}

v.lsp.enable(lsps, {
  capabilities = capabilities,
  on_exit = on_lsp_exit,
})

-- show lsp that is attached to buffer
function _G.LspStatus()
  local bufnr = v.api.nvim_get_current_buf()
  local clients = v.lsp.get_clients({ bufnr = bufnr })
  if #clients == 0 then
    return ''
  end

  local icons = {
    rust_analyzer = '',
    go = '',
    vtsls = '',
    ts_ls = '',
    lua_ls = '',
    biome = '󰐅',
    zls = '',
  }

  local names = {}
  for _, c in ipairs(clients) do
    local icon = icons[c.name] or ''
    table.insert(names, icon .. ' ' .. c.name)
  end
  return table.concat(names, ', ')
end
