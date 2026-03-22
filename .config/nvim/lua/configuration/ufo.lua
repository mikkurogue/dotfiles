local lsp_filetypes = {
	typescript = true,
	typescriptreact = true,
	javascript = true,
	javascriptreact = true,
}

require("ufo").setup({
	provider_selector = function(_bufnr, filetype, _buftype)
		if lsp_filetypes[filetype] then
			return { "lsp", "treesitter" }
		end
		return { "treesitter", "indent" }
	end,
})
