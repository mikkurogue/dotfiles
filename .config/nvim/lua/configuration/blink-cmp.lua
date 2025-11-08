-- COPILOT CORE
require("copilot").setup({
	suggestion = {
		enabled = true, -- enable ghost text
		auto_trigger = true, -- show suggestions automatically
		keymap = {
			accept = "<C-J>", -- accept suggestion
			accept_line = false,
		},
	},
	panel = { enabled = false },
})


-- BLINK CONFIG (load AFTER copilot_cmp.setup)
require("blink.cmp").setup({
	sources = {
		default = {
			'lsp', 'path', 'buffer', 'snippets'
		}
	},
	keymap = {
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = {
			"select_next",
			"fallback",
		},
		["<S-Tab>"] = {
			"select_prev",
			"snippet_backward",
			"fallback",
		},
		["<C-j>"] = {
			"accept",
			function() -- Then try copilot if visible
				local ok, copilot = pcall(require, "copilot.suggestion")
				if ok and copilot.is_visible() then
					copilot.accept()
					return true -- stop the chain
				end
			end,
			"snippet_forward", -- Try snippet forward
			"fallback", -- Finally fallback to default behavior
		},
	},
	completion = {
		list = {
			selection = {
				preselect = true,
				auto_insert = true,
			}
		},
	},
	appearance = {
		use_nvim_cmp_as_default = false,
	},
})
