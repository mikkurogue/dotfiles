require("conform").setup({
	formatters_by_ft = {
		javascript = { "biome_fix", "biome" },
		typescript = { "biome_fix", "biome" },
		javascriptreact = { "biome_fix", "biome" },
		typescriptreact = { "biome_fix", "biome" },
	},
	formatters = {
		biome = {
			command = "biome",
			args = { "format", "--stdin-file-path", "$FILENAME" },
			stdin = true,
		},
		biome_fix = {
			command = "biome",
			args = { "check", "--write", "$FILENAME" },
			stdin = false, -- biome check does not support stdin
			inherit = false
		},
	},
	format_on_save = {
		pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
		timeout_ms = 10000,
		lsp_fallback = true,
	}
})
