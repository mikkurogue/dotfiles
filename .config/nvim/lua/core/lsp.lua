local v = vim

-- LSP capabilities from blink.cmp
local capabilities = require("blink.cmp").get_lsp_capabilities(v.lsp.protocol.make_client_capabilities())

-- Setup Mason for installing LSP servers (use :Mason to install)
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

-- Import LSP configs from nvim-lspconfig (new API for 0.11+)
-- This populates vim.lsp.config with server configurations
require("lspconfig")

-- LSP servers to enable (installed via Mason)
local servers = {
  "rust_analyzer",
  "gopls",
  "vtsls",
  "lua_ls",
  "biome",
  "zls",
  "tailwindcss",
  "vue_ls",
}

-- Apply capabilities to all servers via vim.lsp.config
for _, server in ipairs(servers) do
  v.lsp.config(server, {
    capabilities = capabilities,
  })
end

-- Configure vtsls to also attach to Vue files (required by vue_ls)
v.lsp.config("vtsls", {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
  },
})

-- Enable LSP servers using native vim.lsp API
v.lsp.enable(servers)

-- Show LSP attached to buffer (for statusline)
function _G.LspStatus()
  local bufnr = v.api.nvim_get_current_buf()
  local clients = v.lsp.get_clients({ bufnr = bufnr })
  if #clients == 0 then
    return ''
  end

  local icons = {
    rust_analyzer = ' ',
    gopls = ' ',
    vtsls = ' ',
    ts_ls = ' ',
    lua_ls = ' ',
    biome = '󰐅 ',
    zls = ' ',
    tailwindcss = '󱏿 ',
    vue_ls = ' ',
  }

  local names = {}
  for _, c in ipairs(clients) do
    local icon = icons[c.name] or ''
    table.insert(names, icon .. ' ' .. c.name)
  end
  return table.concat(names, ', ')
end
