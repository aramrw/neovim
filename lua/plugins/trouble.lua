return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	config = function()
		require("trouble").setup({
			modes = {
				diagnostic_float = {
					mode = "diagnostics",
					win = {
						type = "float",
						relative = "editor",
						border = "rounded",
						title = "Diagnostics",
						title_pos = "left",
						size = { width = 0.8, height = 0.5 },
						zindex = 200,
						wrap = true,
					},
				},
				references_float = {
					mode = "lsp_references",
					win = { type = "float" },
				},
			},
			open_no_results = true,
		})
	end,
	keys = {
		{
			"<S-m>",
			"<cmd>Trouble diagnostic_float toggle focus=true<cr>",
			desc = "Diagnostics (Trouble)"
		},
		{
			"<leader>gr",
			"<cmd>Trouble references_float toggle focus=true<cr>",
			desc = "References (Trouble)"
		},
	},
}
