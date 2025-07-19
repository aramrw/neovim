return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	config = function()
		require("trouble").setup({
			follow = true,
			focus = true,
			open_no_results = true,
			modes = {
				diagnostic_float = {
					mode = "diagnostics",
					win = {
						type = "float",
						relative = "editor",
						border = "rounded",
						title = "Diagnostics",
						title_pos = "left",
						size = { width = 0.8, height = 0.95 },
						zindex = 200,
						wrap = true,
					},
				},
				references_float = {
					mode = "lsp_references",
					win = {
						type = "float",
						relative = "editor",
						border = "rounded",
						size = { width = 0.8, height = 0.2 },
						zindex = 200,
						wrap = true,
					},
					preview = {
						type = "float",
						relative = "editor",
						position = { 0, -2 },
						border = "rounded",
						size = { width = 0.3, height = 0.9 },
						zindex = 500,
						wrap = true,
					},
				},
			},
			keys = {
				["<cr>"] = "jump_close",
			}
		})
	end,
	keys = {
		["<cr>"] = "jump_close",
		{
			"<S-m>",
			"<cmd>Trouble diagnostic_float toggle<cr>",
			"Diagnostics",
		},
		-- {
		-- 	"<leader>gr",
		-- 	"<cmd>Trouble references_float toggle<cr>",
		-- 	"References",
		-- }
	},

}
