-- In your lazy.nvim plugins file
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		-- Your standard nvim-treesitter setup.
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "lua", "rust" },
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
		-- vim.treesitter.language.register("rust", "rhai")
		vim.filetype.add {
			extension = {
				ppr = "ppr",
			}
		}
		vim.treesitter.language.register("rust", "rhai")
		vim.treesitter.language.register("rust", "ppr")
	end,
}
