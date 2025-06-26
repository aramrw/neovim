return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		-- Explicitly tell Neovim how to identify .slint files.
		-- This is often the missing piece of the puzzle.
		vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
			pattern = "*.slint",
			callback = function()
				vim.bo.filetype = "slint"
			end,
		})

		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = { "lua", "javascript", "typescript", "rust", "slint" },
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },

			-- This section tells nvim-treesitter where to get the Slint parser from.
			parser_configs = {
				slint = {
					install_info = {
						url = "https://github.com/slint-ui/tree-sitter-slint",
						files = {"src/parser.c"},
						branch = "main",
					},
					filetype = "slint",
				},
			},
		})
	end
}

