return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		-- Your standard nvim-treesitter setup.
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "lua", "rust", "python" },
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})

		-- Set up the custom filetype as 'p' (not 'rust')
		vim.filetype.add {
			extension = {
				p = "p",
			}
		}

		-- Now, register the 'rust' parser to handle the 'p' filetype.
		-- This is the key to getting Rust-like syntax highlighting
		-- without setting the filetype to 'rust'.
		vim.treesitter.language.register("rust", "p")
	end,
}

